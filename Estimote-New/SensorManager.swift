//
//  SensorManager.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/6/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit
import Pods_Estimote_New

/**
 The `SensorManager` is a singleton class that controls communication
 with the Estimote sensors, and manages a list of these sensors. The
 class is indented to update the sensors asyncronously, and their infomration
 can be read from the `connectedSensors` array
 */
final class SensorManager: NSObject, ESTNearableManagerDelegate {
    
    // MARK: - Class Properties
    
    /// Singleton declaration
    static let sharedManager = SensorManager()
    
    /// Nearable manager for Estimote sensors
    let nearableManager = ESTNearableManager()
    
    /// The currently connected sensors from which to pull data
    var connectedSensors: [String:Sensor] = [:]
    
    /// Holds any current error returned by the ESTNearableManager
    var currentError: String?
    
    // Semaphore to wait until ranging a sensor returns either
    // an error or a successful range
    private let rangeSemaphore = DispatchSemaphore(value: 0)
    
    // Background thread sensor update control
    private var backgroundThreadIsOn: Bool = false
    
    // MARK: - Initializers
    
    // Initializer is private to prevent multiple instances
    override private init() {
        super.init()
        
        nearableManager.delegate = self
    }
    
    // MARK: - Sensor Initialization
    
    /**
     
     Will append `connectedSensors` with a new `Sensor` object upon
     successful connection to the sensor with the specified ID
     
     - Parameter id: The ID of the sensor to be connected
     
     - Returns: `nil` or `String` with error
     
     */
    func addSensor(id: String) -> String? {
        nearableManager.startRanging(forIdentifier: id)
        
        // Wait for range request to complete or fail
        rangeSemaphore.wait()
        defer { currentError = nil }
        return currentError
    }
    
    func removeSensor(id: String) {
        connectedSensors.removeValue(forKey: id)
    }
    
    /**
     
     Will ping information from each sensor in `connectedSensors` and
     update their sensor values. Also updates the sensors with any errors
     they may have encountered
     
     - Returns: `nil`
     
     */
    func updateSensorValues() {
        print("[ INF ] Updating Sensors")
        for (id, sensor) in connectedSensors {
            nearableManager.startRanging(forIdentifier: id)
            
            // Check for errors
            // If range for this sensor failed, add that error to its
            // currentError
            rangeSemaphore.wait()
            sensor.currentError = currentError
            currentError = nil
        }
    }
    
    // MARK: - Ranging Delegate Methods
    
    func nearableManager(_ manager: ESTNearableManager, didRangeNearable nearable: ESTNearable) {
        // Update the sensor in the Dictionary
        print("Ranged Sensor: " + nearable.identifier)
        connectedSensors[nearable.identifier] = Sensor(nearable: nearable)
//        currentError = nil
        rangeSemaphore.signal()
    }
    
    func nearableManager(_ manager: ESTNearableManager, rangingFailedWithError error: Error) {
        print("[ ERR ] Ranging failed: " + error.localizedDescription)
        currentError = error.localizedDescription
        rangeSemaphore.signal()
    }
    
    // MARK: - Monitoring Methods
    
    /**
     
     Spawns an asyncronous loop that calls `updateSensorValues()` for
     every `interval` provided. Will mutate `connectedSensors`
     
     - Parameter interval:  The number of seconds between sensor reading calls
     _ Parameter tableView: Reference to a `tableView` object to update
     
     - Returns: `nil`
     
     */
    func beginAsyncronousSensorUpdate(interval: UInt32, tableView: UITableView?) {
        backgroundThreadIsOn = true
        DispatchQueue.global(qos: .userInitiated).async {
            // Background thread
            while self.backgroundThreadIsOn {
                // Update sensors while
                self.updateSensorValues()
                tableView?.reloadData()
                sleep(interval)
            }
            
            print("Async sensor updater stopping")
            return
        }
    }
    
    /**
     
     Terminates the asyncronous loop that calls `updateSensorValues()`
     
     - Returns: `nil`
     
     */
    func stopAsyncronousSensorUpdate() {
        backgroundThreadIsOn = false
    }

}
