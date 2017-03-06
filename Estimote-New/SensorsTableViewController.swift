//
//  SensorsTableViewController.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/6/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit

class SensorsTableViewController: UITableViewController {
    
    /// Array of sensors gathered from the SensorManager
    var connectedSensors: [Sensor] = []
    
    // MARK: - Initalizers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            if let field = alert.textFields?[0] {
                // GET THE TEXT
                // TODO
            } else {
                // Field not filled, do nothing
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
        return connectedSensors.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sensorCell", for: indexPath)
        
        // TODO: Configure Cell
        

        return cell
    }
    
    // Allows the "swiping" action to reveal a delete button. Deleting a sensor will invoke
    // the SensorManager and remove it from the connectedSensors array
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("Delete button pressed")
            
            // TODO: Delete cell at index path
        }
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


    // TODO: Implement Navigation for Cells
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
