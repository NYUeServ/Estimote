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
    
    // MARK: - Outlets
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var accel: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var isMoving: UILabel!
    @IBOutlet weak var currState: UILabel!
    @IBOutlet weak var prevState: UILabel!
    
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
