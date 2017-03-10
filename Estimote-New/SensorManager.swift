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
     
     - Returns: `nil`
     
     */
    func addSensor(id: String) -> String? {
        self.nearableManager.startRanging(forIdentifier: id)
        
        // Wait for range request to complete or fail
        // Lock the async thread from executing while adding
        switch self.rangeSemaphore.wait(timeout: .now() + 5.0) {
        case .success:
            defer { self.currentError = nil }
            return self.currentError
        case .timedOut:
            defer { self.currentError = nil }
            return self.currentError
        }
    }
    
    /**
     
     Safely removes a sensor from the `connectedSensors` array
     
     - Parameter id: String with identifier of Estimote sensor
     
     - Returns: `nil`
     
     */
    func removeSensor(id: String) {
        connectedSensors.removeValue(forKey: id)
    }
    
    // MARK: - Ranging Delegate Methods
    
    func nearableManager(_ manager: ESTNearableManager, didRangeNearable nearable: ESTNearable) {
        // Update the sensor in the Dictionary
        print("Ranged Sensor: " + nearable.identifier)
        connectedSensors[nearable.identifier] = Sensor(nearable: nearable)
        self.rangeSemaphore.signal()
    }
    
    func nearableManager(_ manager: ESTNearableManager, rangingFailedWithError error: Error) {
        // This handles an odd case of an error that is actually harmless
        // This is a bit of a hack
        if error.localizedDescription != "Blueooth is not powerd on." {
            print("[ ERR ] Ranging failed: " + error.localizedDescription)
            self.currentError = error.localizedDescription
            self.rangeSemaphore.signal()
        }
    }
}
