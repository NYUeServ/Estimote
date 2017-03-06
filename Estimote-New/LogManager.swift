//
//  LogManager.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/6/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit

/**
 The `LogManager` is a singleton class that handles the conversion of 
 `Sensor` objects to JSON files. The `LogManager` will maintain a rotating 
 list of sensor logs, which detail their acceleration, temp, etc. 
 */
final class LogManager: NSObject {
    
    /// Singleton declaration
    static let sharedManager = LogManager()
    
    // Initializer is private to prevent multiple instances
    override private init() {
        super.init()
    }
}
