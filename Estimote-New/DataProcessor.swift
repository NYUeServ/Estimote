//
//  DataProcessor.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/6/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit

/**
 The `DataProcessor` class defines a list of methods to parse
 the JSON infomration stored by the `LogManager`. Using tweakable
 thresholds, the `DataProcessor` will destill the sensor information
 down to a (0) if the seat is unoccupied or (1) if the seat is occupied
 
 The number of seats available can then be calculated by summing the number of
 (1)s and divding by the total numebr of sensors reported by the `SensorManager`
 */
class DataProcessor: NSObject {

}
