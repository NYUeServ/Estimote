//
//  SensorsTableViewController.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/6/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit

class SensorsTableViewController: UITableViewController {
    
    private let sensorManager = SensorManager.sharedManager
    
    /// Maintained list of sensor IDs used to refernce `SensorManager.connectedSensors`
    var connectedSensorIDs: [String]
    
    // MARK: - Initalizers
    
    required init?(coder aDecoder: NSCoder) {
        
        // Attach tracked sensors
        connectedSensorIDs = sensorManager.trackingSensorIDs
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table refresh timer
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { _ in
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    func refresh() {
        // Attach tracked sensors array
        connectedSensorIDs = sensorManager.trackingSensorIDs
        tableView.reloadData()
    }
    
    /**
     
     Standard function to show an error popup
     
     - Parameter title:     Title of popup
     - Parameter message:   Message of popup
     
     - Returns: `nil`
     
     */
    func throwErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Action Methods
    
    /**
     
     Presents a pop-up alert allowing the user to enter the new Estimote
     ID for the sensor. This will then invoke the `SensorManager` to attempt a connection
     to the sensor and, if successful, add the sensor to the `connectedSensors` array
     
     - Returns: `nil`
     
     */
    @IBAction func addButtonPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "New Estimote Sensor", message: "Enter the ID of the sensor to add", preferredStyle: .alert)
        
        // Add confirm action
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alert.textFields?[0], let id = field.text {
                // Add this sensor to the ones we wish to track
                if let error = self.sensorManager.addSensor(id: id) {
                    // Error occurred
                    self.throwErrorMessage(title: "Sensor Connection Error", message: error)
                }
                self.refresh()
            }
        }
        
        // Add cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        // Add placeholder text
        alert.addTextField { (textField) in
            textField.placeholder = "Estimote ID"
        }
        
        // Attach actions to alert
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectedSensorIDs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sensorCell", for: indexPath) as! SensorTableViewCell
        let sensor = sensorManager.connectedSensors[connectedSensorIDs[indexPath.row]]
        
        cell.name.text = sensor?.name
        cell.id.text = sensor?.identifier
        
        // If the sensor currently has an error, show the button to present that
        if sensor?.currentError != nil {
            cell.warningButton.isHidden = false
        }
        
        // Display loading if needed
        if sensor?.name == nil || sensor?.identifier == nil {
            cell.isOccupiedLabel.text = "Loading"
            cell.isOccupiedLabel.textColor = .purple
        } else {
            // Set occupancy
            let occupancy = true // TODO
            if occupancy {
                cell.isOccupiedLabel.text = "Occupied"
                cell.isOccupiedLabel.textColor = .red
            } else {
                cell.isOccupiedLabel.text = "Unoccupied"
                cell.isOccupiedLabel.textColor = .green
            }
        }
        
        return cell
    }
    
    // Allows the "swiping" action to reveal a delete button. Deleting a sensor will invoke
    // the SensorManager and remove it from the connectedSensors array
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            // Remove connection info for sensor from array and dictionary
            self.sensorManager.removeSensor(id: self.connectedSensorIDs[index.row])
            self.refresh()
        }
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toSensor" {
            let dest = segue.destination as? SensorViewController
            dest?.currentSensorID = connectedSensorIDs[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}
