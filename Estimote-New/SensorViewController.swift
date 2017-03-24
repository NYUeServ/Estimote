//
//  SensorViewController.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/6/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit

class SensorViewController: UIViewController {

    // MARK: - Class Properties
    
    let sensorManager = SensorManager.sharedManager
    
    var currentSensorID: String!
    
    var occupancyDetector: OccupancyDetector!
    
    // MARK: - Outlets
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var accel: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var isMoving: UILabel!
    @IBOutlet weak var currState: UILabel!
    @IBOutlet weak var prevState: UILabel!
    @IBOutlet weak var cooldownTimer: UILabel!
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateFields()
        Timer.scheduledTimer(timeInterval: 1.0,
                             target: self,
                             selector: #selector(updateFields),
                             userInfo: nil,
                             repeats: true)
    }
    
    func updateFields() {
        if let sensor = sensorManager.connectedSensors[currentSensorID] {
            self.title = sensor.name
            id.text = sensor.identifier
            accel.text = "X: \(sensor.xAcceleration) Y: \(sensor.yAcceleration) Z: \(sensor.zAcceleration)"
            temp.text = "\(sensor.temperature) F"
            isMoving.text = String(describing: sensor.isMoving)
            currState.text = sensor.currentState
            prevState.text = sensor.previousState
            
            if let timer = self.occupancyDetector.cooldownTimers[self.currentSensorID] {
                let timeLeft = timer.fireDate.timeIntervalSinceNow
                let minutesLeft = Int(timeLeft / 60)
                let secondsLeft = Int(timeLeft.truncatingRemainder(dividingBy: 60))
                self.cooldownTimer.text = "\(minutesLeft):\(secondsLeft)"
            } else {
                self.cooldownTimer.text = "( Unoccupied )"
            }
        }
    }
    
    // MARK: - Action Handlers

    /**
     
     Adds an entry to the rename dictionary for the current sensor ID
     This name will display where ever the sensor name would normally be
     displayed.
     
     - Returns: `nil`
     
     */
    @IBAction func renameButtonPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "New Estimote Sensor", message: "Enter the ID of the sensor to add", preferredStyle: .alert)
        
        // Add confirm action
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alert.textFields?[0], let name = field.text {
                self.sensorManager.renamedSensorsDict[self.currentSensorID] = name
            }
        }
        
        // Add cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        // Add placeholder text
        alert.addTextField { (textField) in
            textField.placeholder = "New Name"
        }
        
        // Attach actions to alert
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
}
