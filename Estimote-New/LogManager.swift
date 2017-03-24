//
//  LogManager.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/6/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit
import Alamofire

/**
 
 The `LogManager` is a singleton class that handles the conversion of 
 `Sensor` objects to JSON files. The `LogManager` will maintain a rotating 
 list of sensor logs, which detail their acceleration, temp, etc. Pushes
 occupancy list from the `Occupancy Detector` to the AWS Server.
 
 */
final class LogManager: NSObject {
    
    /// Singleton declaration
    static let sharedManager = LogManager()
    
    // MARK: - Constants
    
    /// URL at which to push logs for interval
    let awsURL = "http://ec2-54-161-116-6.compute-1.amazonaws.com:3000"
    
    // MARK: - Class Properties
    
    // External Managers
    private let sensorManager = SensorManager.sharedManager
    var occupancyDetector: OccupancyDetector?
    
    /// Timer for logging data points to file per day
    private var logTimer: Timer?
    
    /// Time for logging files to disk per day
    private var fileTimer: Timer?
    
    // The JSON data for the current 24 hour period
    private var currentJSON: String = ""
    
    // User defined
    private var logInterval: Int!
    
    // MARK: - Initializers
    
    // Initializer is private to prevent multiple instances
    override private init() {
        super.init()
    }
    
    // MARK: - Log Control
    
    /**
     
     Runs the `log()` method on a `Timer` indefinitely until stopped
     
     - Parameter interval: The interval in seconds at which to make a log file
     
     - Returns: `nil`
     
     */
    func startAutomaticLogging(interval: Int, occupancyDetector: OccupancyDetector) {
        print("[ INF ] Starting automatic logging with interval: \(interval)")
        logInterval = interval
        self.occupancyDetector = occupancyDetector
        logTimer = Timer.scheduledTimer(timeInterval: Double(interval),
                                        target: self,
                                        selector: #selector(log),
                                        userInfo: nil,
                                        repeats: true)
        fileTimer = Timer.scheduledTimer(timeInterval: 86400,
                                         target: self,
                                         selector: #selector(logFile),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    /**
     
     Stops automatic logging
     
     - Returns: `nil`
     
     */
    func stopAutomaticLogging() {
        print("[ INF ] Stopping automatic logging")
        // Stop logging
        logTimer?.invalidate()
        fileTimer?.invalidate()
    }
    
    /**
     
     Log Routine. Serializes all sensors to JSON and appends them to a
     running JSON string for the current 24 hour period
     
     - Returns: `nil`
     
     */
    func log() {
        
        // Push binary occupancy states to server
        pushToAWS()
        
        // Get date string
        let date = Date()
        let cal  = Calendar.current
        let comp = cal.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        if let y = comp.year, let m = comp.month, let d = comp.day,
            let h = comp.hour, let mi = comp.minute {
            
            // Convert object to dict
            let dateString = "\(y)-\(m)-\(d)-\(h):\(mi)"
            var jsonDict: [String: AnyObject] = [:]
            var sensorsDict: [String: AnyObject] = [:]
            for (_, sensor) in sensorManager.connectedSensors {
                let sensorDict: [String: AnyObject] = [
                    "name"          : sensor.name as AnyObject,
                    "xAcceleration" : sensor.xAcceleration as AnyObject,
                    "yAcceleration" : sensor.yAcceleration as AnyObject,
                    "zAcceleration" : sensor.zAcceleration as AnyObject,
                    "isMoving"      : sensor.isMoving as AnyObject,
                    "temperature"   : sensor.temperature as AnyObject,
                    "currentState"  : sensor.currentState as AnyObject,
                    "previousState" : sensor.previousState as AnyObject
                ]
                
                sensorsDict["\(sensor.identifier)"] = sensorDict as AnyObject
            }
            
            jsonDict[dateString] = sensorsDict as AnyObject
            
            // Convert to JSON
            do {
                let json = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
                if let jsonString = String(data: json, encoding: .utf8) {
                    // Append string to the rest of the JSON
                    self.currentJSON += "\n" + jsonString
                }
            } catch {
                print("[ ERR ] Could not serialize JSON")
            }
        }
    }
    
    /**
     
     Writes the `currentJSON` string to a file with name of the current date.
     Runs every 24 hours.
     
     - Returns: `nil`
     
     */
    func logFile() {
        
        // Stop logging for a moment
        stopAutomaticLogging()
        
        // Get file name
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let filename = "\(formatter.string(from: Date())).json"
        
        // Get file path
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(filename)
            
            // Write to file
            do {
                try self.currentJSON.write(to: path, atomically: false, encoding: .utf8)
                
                // Success, clear current JSON
                self.currentJSON = ""
                
            } catch {
                NSLog("[ ERR ] Error wrting to file")
            }
        }
        
        // Return to logging
        startAutomaticLogging(interval: self.logInterval, occupancyDetector: self.occupancyDetector!)
    }
    
    
    /**
     
     Deletes all log files
     
     - Returns: `nil`
     
     */
    func clearLogs() {
        // TODO
    }
    
    // MARK: - External Communications
    
    /**
     
     Will push the current JSON log dict to the specified server.
     This will run when ever a new log entry is made for the specified
     interval
     
     - Returns: `nil`
     
     */
    func pushToAWS() {
        
        // Check Occupancy Detector is valid
        if let occ = occupancyDetector?.occupancyDictionary {
            
            // Build Sensor States
            // This will represent a JSON dict with the name
            // followed by a boolean of its occupancy
            var sensorStates: [String: Bool] = [:]
            for (sensorID, isOccupied) in occ {
                if let name = self.sensorManager.connectedSensors[sensorID]?.name {
                    sensorStates[name] = isOccupied
                } else {
                    sensorStates[sensorID] = isOccupied
                }
            }
            
            // Get date string
            let date = Date()
            let cal  = Calendar.current
            let comp = cal.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            if let y = comp.year, let m = comp.month, let d = comp.day,
                let h = comp.hour, let mi = comp.minute {
                
                // Convert object to dict
                let dateString = "\(y)-\(m)-\(d)-\(h):\(mi)"
                let transferDict: [String: AnyObject] = [ "timestamp":dateString as AnyObject,
                                                          "sensors":sensorStates as AnyObject ]
                
                // Push to server
                Alamofire.request(awsURL,
                                  method: .post,
                                  parameters: transferDict,
                                  encoding: JSONEncoding.default,
                                  headers: nil).response(completionHandler:
                                    { resp in
                                        if let err = resp.error {
                                            print("[ ERR ] Could not push to server: \(err)")
                                        } else {
                                            print("[ INF ] Server Push OK")
                                        }
                                  })
                
            }
            
        } else {
            print("[ ERR ] Could not push occupancy to server: No Occupancy Detector")
        }
    }
}
