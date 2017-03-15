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
    
    /**
     
     The interrupt dictionary will contain the states of an
     Estimote sensor for which consitutes as "occupied"
     If these values are found at all during a predefined interval,
     then the sensor will be marked as "occupied" for that interval.
     
     - Example: `interruptDictionary["isMoving"] = true` Will trigger
     a positive occupancy result for the current interval
     
     Supported types: String (isEqual),       Int (isGreaterThan),
                      Double (isGreaterThan), Bool (isEqual)
     
     */
    var interruptDictionary: [String: Any] = [:]
    
    // The defined update interval in **SECONDS**
    private let unoccupiedInterval: Int
    
    private var previousSensorList: [String: Sensor] = [:]
    
    /// The current occupancy for all sensors (IDs)
    lazy var occupancyDictionary: [String: Bool] = [:]
    
    /// The cooldown timers for each sensor ID
    lazy var cooldownTimers: [String: Timer] = [:]
    
    private let sensorManager = SensorManager.sharedManager
    
    // MARK: - Initializers
    
    /// Initializes with an update interval in **MINUTES**
    init(unoccupiedInterval: Int, interruptDictionary: [String: Any]) {
        
        // Init update interval in seconds
        self.unoccupiedInterval = unoccupiedInterval * 60
        
        // Init interrupt dictionary
        self.interruptDictionary = interruptDictionary
        
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
        
        print("=== Detector init complete")
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
            for (rule, threshold) in self.interruptDictionary {
                var matchCount = 0
                print("rule: \(rule)")
                // Compare current sensor to its previous state
                
                // Check if its a new sensor
                if self.previousSensorList.keys.contains(currentId) {
                    // Not new sensor
                    let prevSensor = self.previousSensorList[currentId]
                    if let comparison = currentSensor.value(forKey: rule) {
                        print(currentSensor.isMoving)
                        switch comparison {
                            
                        case is String:
                            // Test equality to treshold
                            if (threshold as! String == comparison as! String) { matchCount += 1 }
                            
                        case is Int:
                            // Special case
                            if rule == "cumulativeAcc" {
                                if accelChange(acc1: prevSensor!.cumulativeAcc,
                                               acc2: currentSensor.cumulativeAcc,
                                               threshold: threshold as! Int)
                                { matchCount += 1 }
                                
                            } else {
                                print("t: \(threshold), c: \(comparison)")
                                if (threshold as! Int) < (comparison as! Int) { matchCount += 1 } // TODO: Weird bug here with bools
                                
                            }
                            
                        case is Double:
                            // Test greater than
                            if (threshold as! Double) < (comparison as! Double)
                            { matchCount += 1 }
                            
                        case is Bool:
                            // Test equality
                            if (threshold as! Bool) == (comparison as! Bool)
                            { matchCount += 1 }
                            
                        default:
                            // Error
                            print("[ WRN ] Comparing unsupported types")
                            
                        }
                    } else {
                        print("[ ERR ] Invalid rule for occupancy comparison")
                    }
                } else {
                    // New Sensor, no comparable data, skipping
                }
                
                // Set the current sensors as the prvious sensors
                self.previousSensorList = currentSensors
                
                // Commit occupancy states
                occDict[currentId] = (matchCount > 0)
                print("\(occDict) ====== END \(matchCount)")
            }
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
                print("\(id) is occupied and getting a fresh timer")
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

        for (id, isOccupied) in self.occupancyDictionary {
            if currentOccupancy.keys.contains(id) {
                // Keys exist in both old and current
                // Update occupancy
                self.occupancyDictionary[id] = currentOccupancy[id]!
            } else {
                // There is an old key that is not in the current list
                self.occupancyDictionary[id] = nil
            }
        }
        
        self.cooldownTimers = currentCooldownTimers
    }
    
    // MARK: - Value Comparison Toolkit
    
    /**
     
     Returns true if the difference of two cumulative acceleration 
     value sums exceed the threshold value.
     
     - Parameter acc1: The first cumulative value of X,Y,Z acceleration
     - Parameter acc2: The second cumulative value of X,Y,Z acceleration
     - Parameter treshold: The maximum (inclusive) difference of the two sums,
     above which a `true` value will be returned
     
     - Returns: `bool` Exceeded treshold
     
     */
    func accelChange(acc1: Int, acc2: Int, threshold: Int) -> Bool {
        return ((abs(acc1) - abs(acc2)) >= threshold)
    }
}
