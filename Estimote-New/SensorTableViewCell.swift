//
//  SensorTableViewCell.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/6/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit

class SensorTableViewCell: UITableViewCell {
    
    // MARK: - Cell Outlets
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var isOccupiedLabel: UILabel!
    @IBOutlet weak var warningButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        warningButton.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Displays a pop-up view with the encountered error
    @IBAction func warningButtonPressed(_ sender: AnyObject) {
        // TODO: Present a pop-up with warning info
    }
    

}
