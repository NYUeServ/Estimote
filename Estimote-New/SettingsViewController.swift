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
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - View Handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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
