//
//  SensorManager.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/6/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit

/**
 The `SensorManager` is a singleton class that controls communication
 with the Estimote sensors, and manages a list of these sensors. The
 class is indented to update the sensors asyncronously, and their infomration
 can be read from the `connectedSensors` array
 */
final class SensorManager: NSObject {
    
    /// Singleton declaration
    static let sharedManager = SensorManager()
    
    /// The currently connected sensors from which to pull data
    var connectedSensors: [Sensor] = []
    
    // Initializer is private to prevent multiple instances
    override private init() {
        super.init()
    }
    
    /**
     
     Will ping information from each sensor in `connectedSensors` and
     update their sensor values
     
     - Returns: `nil` or `SensorConnectionError`
     
     */
    func updateSensorValues() throws {
        
    }
    
    /**
     
     Will append `connectedSensors` with a new `Sensor` object upon
     successful connection to the sensor with the specified ID
     
     - Parameter id: The ID of the sensor to be connected
     
     - Returns: `nil` or `SensorConnectionError`
     
     */
    func addSensor(id: String) throws {
        
    }
    
    /**
     
     Spawns an asyncronous loop that calls `updateSensorValues()` for
     every `interval` provided. Will mutate `connectedSensors`
     
     - Parameter interval: The number of seconds between sensor reading calls
     
     - Returns: `nil`
     
     */
    func beginAsyncronousSensorUpdate(interval: Int) {
        
    }
    
    /**
     
     Terminates the asyncronous loop that calls `updateSensorValues()`
     
     - Returns: `nil`
     
     */
    func stopAsyncronousSensorUpdate() {
        
    }
    
//    /**
//     
//     Safely returns the `connectedSensors` array
//     
//     - Returns: [Sensor]
//     
//     */
//    func getConnectedSensorsForCurrentTime() -> [Sensor] {
//        
//    }

}
