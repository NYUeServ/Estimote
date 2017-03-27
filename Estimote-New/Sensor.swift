//
//  Sensor.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/6/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit
import Foundation

/**
 
 The `Sensor` class defines the metrics we wish to store
 about each Estimote sensor. Each `Sensor` object's info in 
 the `SensorManager`'s `connectedSensors` array is subject to 
 change, per the interval of update defined by `SensorManager`.
 
 */
class Sensor: NSObject {
    
    // Acceleration
    var xAcceleration: Int
    var yAcceleration: Int
    var zAcceleration: Int
    var acc: Double {
        return round(sqrt(Double(xAcceleration * xAcceleration + yAcceleration *
            yAcceleration + zAcceleration * zAcceleration))*1000)/1000
    }
    var cumulativeAcc: Double {
        return sqrt( Double(pow(Double(xAcceleration), 2) +
                            pow(Double(yAcceleration), 2) +
                            pow(Double(zAcceleration), 2))
        )
//        return abs(xAcceleration) + abs(yAcceleration) + abs(zAcceleration)
    }
    
    // States
    var isMoving:      Bool
    var temperature:   Double
    var currentState:  String
    var previousState: String
    
    // Attributes
    var name:       String
    var identifier: String
    var type:       String
    var color:      String
    
    // Error Handling
    var currentError:String?
    
    // This is a special value that allows for dynamic
    // acceleration thresholding. If a sensor is found to
    // be experiencing background noise in its accelteration sensor,
    // its average acceleration change sum will be reported here.
    // It is calculated as the average of `acc` over time unoccupied.
    var backgroundNoiseCoefficient: Int = 0
    
    init(nearable: ESTNearable) {
        
        // Set acceleration and current states from
        // ESTNearable object
        self.xAcceleration = nearable.xAcceleration
        self.yAcceleration = nearable.yAcceleration
        self.zAcceleration = nearable.zAcceleration
        self.isMoving      = nearable.isMoving
        self.temperature   = nearable.temperature
        self.identifier    = nearable.identifier
        
        // Set the sensor Type
        switch nearable.type.rawValue {
        case 1: self.type  = "Dog"
        case 2: self.type  = "Car"
        case 3: self.type  = "Fridge"
        case 4: self.type  = "Bag"
        case 5: self.type  = "Bike"
        case 6: self.type  = "Chair"
        case 7: self.type  = "Bed"
        case 8: self.type  = "Door"
        case 9: self.type  = "Shoe"
        case 10: self.type = "Generic"
        case 11: self.type = "All"
        default: self.type = "Unknown"
        }
        
        // Set the sensor Color
        switch nearable.color.rawValue {
        case 1: self.color  = "Mint Cocktail"
        case 2: self.color  = "Icy Marshmallow"
        case 3: self.color  = "Blueberry Pie"
        case 4: self.color  = "Sweet Beetroot"
        case 5: self.color  = "Candy Floss"
        case 6: self.color  = "Lemon Tart"
        case 7: self.color  = "Vanilla Jello"
        case 8: self.color  = "Liquorice Swirl"
        case 9: self.color  = "White"
        case 10: self.color = "Black"
        case 11: self.color = "Transparent"
        default: self.color = "Unknown"
        }
        
        // Set sensor Name, Previous State, and Current State
        self.name = "\(self.color) \(self.type)"
        self.currentState = "\(nearable.currentMotionStateDuration)"
        self.previousState = "\(nearable.previousMotionStateDuration)"
        
        super.init()
    }
    
    convenience override init() {
        self.init(nearable: ESTNearable())
        
        self.xAcceleration = 0
        self.yAcceleration = 0
        self.zAcceleration = 0
        self.isMoving      = false
        self.temperature   = 0.0
        self.identifier    = ""
        self.name          = ""
    }
    
}

/**
 
  Used to compare one (or two) sensor object(s) by comparing
  the differences or using the thresholds defined in this struct.
  All values default to nil and the user can choose the ones they
  want to use by assiging them.
 
 */
struct SensorComparator {
    
    // Acceleration
    var xAcceleration: Int?
    var yAcceleration: Int?
    var zAcceleration: Int?
    
    // States
    var isMoving:      Bool?
    var temperature:   Double?
    var currentState:  String?
    var previousState: String?
    
    var accelerationChangeThreshold: Int?
    var temperatureChangeThreshold: Double?
    
//    static func thresholdIntChange(val1: Int, val2: Int, threshold: Int) -> Bool {
//        return ((abs(val1) - abs(val2)) >= threshold)
//    }
    
    static func thresholdDoubleChange(val1: Double, val2: Double, threshold: Double) -> Bool {
        return ((abs(val1) - abs(val2)) >= threshold)
    }
}
