//
//  NewSensorsTableViewController.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/12/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit

class NewSensorsTableViewController: UITableViewController {

    // MARK: - Class Properties
    
    private let sensorManager = SensorManager.sharedManager
    var foundSensors: [Sensor] = []
    
    // MARK: - View Handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Begin searching area for all new nearables
        sensorManager.nearableManager.startRanging(for: .all)
        
        // Table refresh timer
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { _ in
            if let s = self.sensorManager.foundSensorsBuffer {
                let sortedByID = s.values.sorted(by: { $0.identifier > $1.identifier})
                self.foundSensors = sortedByID
            }
            self.tableView.reloadData()
        })
    }
    
    func throwErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Action Handlers
    
    /**
     
     Will access the found sensors buffer from the SensorManager
     and display them on the table, sorted by Sensor ID
     
     - Returns: `nil`
     
     */
    @IBAction func refreshPressed(_ sender: AnyObject) {
        
        if let s = sensorManager.foundSensorsBuffer {
            let sortedByID = s.values.sorted(by: { $0.identifier > $1.identifier})
            foundSensors = sortedByID
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundSensors.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newSensorCell", for: indexPath) as UITableViewCell

        cell.textLabel?.text = foundSensors[indexPath.row].name
        cell.textLabel?.textColor = .purple
        cell.detailTextLabel?.text = foundSensors[indexPath.row].identifier

        return cell
    }
    
    // Allows the "swiping" action to reveal a delete button. Deleting a sensor will invoke
    // the SensorManager and remove it from the connectedSensors array
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let add = UITableViewRowAction(style: .normal, title: "Add") { action, index in
            if self.sensorManager.trackingSensorIDs.contains(self.foundSensors[index.row].identifier) {
                // Already Tracking
                self.throwErrorMessage(title: "Already Tracking Sensor", message: "")
            } else {
                // Add connection info for sensor from array and dictionary
                if let error = self.sensorManager.addSensor(id: self.foundSensors[index.row].identifier) {
                    // Error occurred
                    self.throwErrorMessage(title: "Error When Adding", message: error)
                } else {
                    self.throwErrorMessage(title: "Successly Added!", message: "")
                }
            }
        }
        add.backgroundColor = .purple
        
        return[add]
    }
}
