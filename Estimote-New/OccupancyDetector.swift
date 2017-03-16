//
//  OccupancyDetector.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/15/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit

/**
 
 The `OccupancyDetector` class implements a set of
 methods that accept defined interrupts and calculates
 the "occupancy" for the chair in which the Estimote
 sensor is attached. This class will keep a constantly-updated
 list of connect sensors as a binary (1) occupied, or (0) unoccupied.
 This list will be forwarded to the AWS servers at defined intervals.
 Each `Sensor` will get its own cooldown timer which ticks for the defined
 interval. It is reset if an iterrupt is detected. If it times out, the sensor
 is then considered unoccupied.
 
 */
class OccupancyDetector: NSObject {
    
    // MARK: - Class Propertise
    
    /**
     
     The interrupt values and threshold values for which
     action is to be taken if the defined conditions are met 
     for a sensor
     
     */
    var interruptValues: SensorComparator
    
    /// The current occupancy for all sensors (IDs)
    lazy var occupancyDictionary: [String: Bool] = [:]
    
    /// The cooldown timers for each sensor ID
    lazy var cooldownTimers: [String: Timer] = [:]
    
    // The defined update interval in **SECONDS**
    private let unoccupiedInterval: Int
    
    // The list of sensors from the previous or original reading
    private var previousSensorList: [String: Sensor] = [:]
    
    private let sensorManager = SensorManager.sharedManager
    
    // MARK: - Initializers
    
    /// Initializes with an update interval in **MINUTES**
    init(unoccupiedInterval: Int, interruptValues: SensorComparator) {
        
        print("[ INF ] Starting Occupancy Detector")
        
        // Init update interval in seconds
        self.unoccupiedInterval = unoccupiedInterval * 60
        
        // Init interrupt value (Sensor Comparator)
        self.interruptValues = interruptValues
        
        // Init self
        super.init()
        
        // Init occupancy recording (default all to false)
        // Create cooldown timers for all sensors
        for s in sensorManager.trackingSensorIDs {
            occupancyDictionary[s] = false
            cooldownTimers[s] = createCooldownTimer(sensorID: s)
        }
        
        // Get first state of sensors
        previousSensorList = sensorManager.connectedSensors
    }
    
    // MARK: - Timekeeping
    
    func createCooldownTimer(sensorID: String) -> Timer {
        let timer = Timer.scheduledTimer(withTimeInterval: Double(unoccupiedInterval), repeats: false, block: { _ in
            // The sensor reached the end of its timer without interrupt, set unoccupied
            print("[ INF ] The chair for sensor \(sensorID) is now unoccupied")
            self.occupancyDictionary[sensorID] = false
        })
        return timer
    }
    
    // MARK: - Dictionary Control
    
    /**
     
     Searches for changes in the current connected sensors
     and reports the sensors as occupied if changes occurred or
     unoccupied if no changes in state where found
     
     - Returns: `[String: Bool]` an occupancy dictionary
     
     */
    func getCurrentOccupancyDictionary() -> [String: Bool] {
            
        var occDict: [String: Bool] = [:]
        let currentSensors = self.sensorManager.connectedSensors
        
        for (currentId, currentSensor) in currentSensors {
            
            var matchCount = 0
            
            // Check if its a new sensor
            if self.previousSensorList.keys.contains(currentId) {
                // Not new sensor
                let prevSensor = self.previousSensorList[currentId]
                
                // Check accel change
                if let acc =  interruptValues.accelerationChangeThreshold {
                    if SensorComparator.thresholdIntChange(val1: prevSensor!.cumulativeAcc,
                                                           val2: currentSensor.cumulativeAcc,
                                                           threshold: acc) { matchCount += 1 }
                }
                
                // Check isMoving
                if let mov = interruptValues.isMoving {
                    if currentSensor.isMoving == mov { matchCount += 1 }
                }
                
                // Check temperature
                if let temp = interruptValues.temperatureChangeThreshold {
                    if SensorComparator.thresholdDoubleChange(val1: prevSensor!.temperature,
                                                              val2: currentSensor.temperature,
                                                              threshold: temp) { matchCount += 1 }
                }
                
            } else {
                // New Sensor, no comparable data, skipping
            }
            
            // Set the current sensors as the prvious sensors
            self.previousSensorList = currentSensors

            // Commit occupancy states
            occDict[currentId] = (matchCount > 0)
        }
        
        return occDict
    }
    
    /**
     
     Computes new cooldown timers given the current occupancy. If a
     sensor reports that it is occupied, then it should get a fresh cooldown
     timer. If not, then it will pass the current timer, if it's still ticking.
     By the end of this method, only *occupied* sensors should have cooldown timers.
     
     - Parameter forOccupancy: The occupancy dictionary to compare against
     
     - Returns: `nil`
     
     */
    func getCurrentCooldownTimers(forOccupancy: [String: Bool]) -> [String: Timer] {
        
        var coolDict: [String: Timer] = [:]
        let currentOccupancyDict = forOccupancy
        
        for (id, isOccupied) in currentOccupancyDict {
            
            // Add the currently ticking timers
            for (_, timer) in cooldownTimers {
                if timer.isValid {
                    coolDict[id] = timer
                }
            }
            
            // If it's occupied, it needs a fresh timer
            if isOccupied {
                print("[ INF ] \(id) is occupied and getting a fresh timer")
                coolDict[id]?.invalidate()
                coolDict[id] = createCooldownTimer(sensorID: id)
            }
        }
        
        return coolDict
    }
    
    /**
     
     This function will compare the current occupancy to the last
     reported occupancy and update the values. It will also remove deleted
     sensors from occupancy tracking and update the cooldown timers. This function
     can run on loop in a background thread, since it *should* be the only method
     that mutates the dictionaries directly
     
     - Returns: `nil`
     
     */
    
    func updateDictionaries() {
        let currentOccupancy = getCurrentOccupancyDictionary()
        let currentCooldownTimers = getCurrentCooldownTimers(forOccupancy: currentOccupancy)

        // Fold in the current sensor values to list
        for (id, _) in currentOccupancy {
            if let occ = self.occupancyDictionary[id] {
                // Only the timers should alter the values of
                // occupied sensors
                if !occ {
                    self.occupancyDictionary[id] = currentOccupancy[id]!
                }
            } else {
                // Add in the new sensor value
                self.occupancyDictionary[id] = currentOccupancy[id]!
            }
        }
        
        // Sanitize old sensors that are no longer tracked
        for (id, _) in self.occupancyDictionary {
            if !currentOccupancy.keys.contains(id) {
                self.occupancyDictionary[id] = nil
            }
        }
        
        // Set the cooldown timers
        self.cooldownTimers = currentCooldownTimers
    }
}
