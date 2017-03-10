//
//  CommunicationManager.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/6/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit

/**
 The `CommunicationManager` is a singleton class that controls communication
 with AWS. The states of each sensor are sent as JSON via HTTP at defined intervals. 
 The JSON contains a list of integers (0 or 1), by Estimote sensor ID name.
 0: Unoccupied seat
 1: Occupied seat
 */
final class CommunicationManager: NSObject {
    
    /// Singleton declaration
    static let sharedManager = CommunicationManager()
    
    /// URL where states will be uploaded
    let baseUrl: String = "http://ec2-54-161-116-6.compute-1.amazonaws.com:3000"
    
    // Initializer is private to prevent multiple instances
    override private init() {
        super.init()
    }
}
