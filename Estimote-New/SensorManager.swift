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
 can be read from the `connectedSensors` array.
 
 */
final class SensorManager: NSObject, ESTNearableManagerDelegate {
    
    // MARK: - Class Properties
    
    /// Singleton declaration
    static let sharedManager = SensorManager()
    
    /// Nearable manager for Estimote sensors
    let nearableManager = ESTNearableManager()
    
    /// The IDs of the sensors that the user explicitly added
    var trackingSensorIDs: [String] = []
    
    /// The currently connected sensors from which to pull data
    var connectedSensors: [String:Sensor] = [:]
    
    /// When searching for all Nearable sensors, the ones discovered can be found here
    var foundSensorsBuffer: [String:Sensor]?
    
    /// If a sensor was renamed, a name with its ID is stored here
    var renamedSensorsDict: [String:String] = [:]
    
    /// Holds any current error returned by the ESTNearableManager
    var currentError: String?
    
    // Semaphore to wait until ranging a sensor returns either
    // an error or a successful range
    private let rangeSemaphore = DispatchSemaphore(value: 0)
    
    // MARK: - Initializers
    
    // Initializer is private to prevent multiple instances
    override private init() {
        super.init()
        nearableManager.delegate = self
        
        // Load tracked sensors, and renames from memory
        self.loadSensorIDs()
        
        // Begin ranging for sensors
        for s in trackingSensorIDs {
            nearableManager.startRanging(forIdentifier: s)
        }
    }
    
    // MARK: - Sensor Initialization
    
    /**
     
     Will append `connectedSensors` with a new `Sensor` object upon
     successful connection to the sensor with the specified ID
     
     - Parameter id: The ID of the sensor to be connected
     
     - Returns: `nil`
     
     */
    func addSensor(id: String) -> String? {
        print("[ INF ] Adding sensor: \(id)")
        
        // Begin ranging for this ID
        self.nearableManager.startRanging(forIdentifier: id)
        
        // Wait for range request to complete or fail
        // Lock the async thread from executing while adding
        defer { self.currentError = nil }
        switch self.rangeSemaphore.wait(timeout: .now() + 5.0) {
        case .success:
            if self.currentError == nil {
                // No errors reported, commit to tracking array
                self.trackingSensorIDs.append(id)
                self.saveSensorIDs()
            }
            return self.currentError
        case .timedOut:
            return "Operation Timed Out"
        }
    }
    
    /**
     
     Safely removes a sensor from the `connectedSensors` array
     
     - Parameter id: String with identifier of Estimote sensor
     
     - Returns: `nil`
     
     */
    func removeSensor(id: String) {
        print("[ INF ] Removing sensor: \(id)")
        trackingSensorIDs = trackingSensorIDs.filter() {$0 != id}
        connectedSensors.removeValue(forKey: id)
        saveSensorIDs()
    }
    
    // MARK: - Ranging Delegate Methods
    
    /**
     
     Ran when a sensor successfully reports its data
     
     - Parameter manager:   The nearable manager
     - Parameter nearable:  The found nearable
     
     - Returns: `nil`
     
     */
    func nearableManager(_ manager: ESTNearableManager, didRangeNearable nearable: ESTNearable) {
        // Update the sensor in the Dictionary
        connectedSensors[nearable.identifier] = Sensor(nearable: nearable)
        
        // Check for custom name
        if let rename = self.renamedSensorsDict[nearable.identifier] {
            connectedSensors[nearable.identifier]?.name = rename
            self.saveSensorIDs()
        }
        
        self.rangeSemaphore.signal()
    }
    
    /**
     
     Runs when the manager encounters an error when ranging
     
     - Parameter manager:   The nearable manager
     - Parameter error:     The reported error for failure
     
     - Returns: `nil`
     
     */
    func nearableManager(_ manager: ESTNearableManager, rangingFailedWithError error: Error) {
        // This handles an odd case of an error that is actually harmless
        // This is a bit of a hack
        if error.localizedDescription != "Blueooth is not powerd on." {
            print("[ ERR ] Ranging failed: " + error.localizedDescription)
            self.currentError = error.localizedDescription
            self.rangeSemaphore.signal()
        }
    }
    
    /**
     
     Runs when the manager is instructed to range for all nearables
     in the area
     
     - Parameter manager:   The nearable manager
     - Parameter nearables:  The found nearables

     - Returns: `nil`
     
     */
    func nearableManager(_ manager: ESTNearableManager, didRangeNearables nearables: [ESTNearable], with type: ESTNearableType) {
        var foundDict: [String: Sensor] = [:]
        for n in nearables {
            let sensor = Sensor(nearable: n)
            
            // Check for custom name
            if let rename = self.renamedSensorsDict[sensor.identifier] {
                sensor.name = rename
                self.saveSensorIDs()
            }
            
            foundDict[sensor.identifier] = sensor
        }
        self.foundSensorsBuffer = foundDict
    }
    
    // MARK: - Saving
    
    /**
     
     Save the array of tracked sensors to User Defaults
     
     - Returns: `nil`
     
     */
    func saveSensorIDs() {
        let defaults = UserDefaults.standard
        defaults.set(self.trackingSensorIDs, forKey: "sensors")
        defaults.set(self.renamedSensorsDict, forKey: "renamedSensors")
    }
    
    /**
     
     Lost the array of tracked sensors from User Defaults
     
     - Returns: `nil`
     
     */
    func loadSensorIDs() {
        let defaults = UserDefaults.standard
        if let ids = defaults.array(forKey: "sensors") {
            for s in ids {
                self.trackingSensorIDs.append(s as! String)
            }
        }
        
        if let names = defaults.dictionary(forKey: "renamedSensors") {
            for (sensor, name) in names {
                self.renamedSensorsDict[sensor] = name as? String
            }
        }
    }
}
