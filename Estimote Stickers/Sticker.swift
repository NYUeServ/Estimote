//
//  Sticker.swift
//  Estimote Stickers
//
//  Created by Jonathan Poch on 1/18/17.
//  Copyright © 2017 Jonathan Poch. All rights reserved.
//

import Foundation

struct Sticker {
    var xAcceleration: Int
    var yAcceleration: Int
    var zAcceleration: Int
    var isMoving: Bool
    var temperature: Double
    var identifier: String
    var type: String
    var color: String
    var name: String
//    let date: String = {
//        var date = NSDate()
//        var df: NSDateFormatter = NSDateFormatter()
//        df.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
//        print("DATE: \(df.stringFromDate(date))")
//        return df.stringFromDate(date)
//    }()
    var currentState: String
    var previousState: String
    
    init(nearable: ESTNearable) {
        self.xAcceleration = nearable.xAcceleration
        self.yAcceleration = nearable.yAcceleration
        self.zAcceleration = nearable.zAcceleration
        self.isMoving = nearable.isMoving
        self.temperature = nearable.temperature
        self.identifier = nearable.identifier
        
        switch nearable.type.rawValue {
        case 1: self.type = "Dog"
        case 2: self.type = "Car"
        case 3: self.type = "Fridge"
        case 4: self.type = "Bag"
        case 5: self.type = "Bike"
        case 6: self.type = "Chair"
        case 7: self.type = "Bed"
        case 8: self.type = "Door"
        case 9: self.type = "Shoe"
        case 10: self.type = "Generic"
        case 11: self.type = "All"
        default: self.type = "Unknown"
        }
        switch nearable.color.rawValue {
        case 1: self.color = "Mint Cocktail"
        case 2: self.color = "Icy Marshmallow"
        case 3: self.color = "Blueberry Pie"
        case 4: self.color = "Sweet Beetroot"
        case 5: self.color = "Candy Floss"
        case 6: self.color = "Lemon Tart"
        case 7: self.color = "Vanilla Jello"
        case 8: self.color = "Liquorice Swirl"
        case 9: self.color = "White"
        case 10: self.color = "Black"
        case 11: self.color = "Transparent"
        default: self.color = "Unknown"
        }
        
        self.name = "\(self.color) \(self.type)"
        self.currentState = "\(nearable.currentMotionStateDuration)"
        self.previousState = "\(nearable.previousMotionStateDuration)"

    }
}
