//
//  SensorTableViewCell.swift
//  Estimote-New
//
//  Created by Cole Smith on 3/6/17.
//  Copyright © 2017 Cole Smith. All rights reserved.
//

import UIKit

class SensorTableViewCell: UITableViewCell {

    // MARK: - Cell Properties
    
    var isOccupied: Bool = false
    
    // MARK: - Cell Outlets
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var isOccupiedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if isOccupied {
            isOccupiedLabel.text = "OCCUPIED"
        } else {
            isOccupiedLabel.text = "UNOCCUPIED"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
