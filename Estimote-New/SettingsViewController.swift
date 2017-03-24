//
//  SettingsViewController.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/6/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loggingIntervalField: UITextField!
    @IBOutlet weak var sensitivityField: UITextField!
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - View Handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Load from defaults
        var logInterval = UserDefaults.standard.integer(forKey: "logInterval")
        var threshold   = UserDefaults.standard.integer(forKey: "sensitivity")
        
        // Not set by user, default to 5 minutes
        if logInterval == 0 { logInterval = 5 }
        if threshold   == 0 { threshold   = 10 }
        
        // Set loaded values to placeholder
        loggingIntervalField.placeholder = String(logInterval)
        sensitivityField.placeholder     = String(threshold)
    }
    
    func throwErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Action Handlers
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        saveSettings()
    }
    
    /**
     
     Resets the rename dictionary to contain no renames
     
     - Returns: `nil`
     
     */
    @IBAction func resetRenamesPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Really Reset All Renames?",
                                      message: "All custom names will be reset to default names.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
          let sm = SensorManager.sharedManager
            sm.renamedSensorsDict = [:]
            sm.saveSensorIDs()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Saving
    
    /**
     
     Writes to UserDefaults to save the settings under this view controller
     
     - Returns: `nil`
     
     */
    func saveSettings() {
        let defaults = UserDefaults.standard
        if let t = loggingIntervalField.text, let i = Int(t) {
            defaults.set(i, forKey: "logInterval")
        }
        if let s = sensitivityField.text, let i = Int(s) {
            defaults.set(i, forKey: "sensitivity")
        }
        throwErrorMessage(title: "Save Success", message: "Changes will take effect on restart.")
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
