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
