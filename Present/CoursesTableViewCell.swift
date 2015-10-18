//
//  CoursesTableViewCell.swift
//  Present
//
//  Created by Siddarth Sivakumar on 10/16/15.
//  Copyright © 2015 Siddarth Sivakumar. All rights reserved.
//

import UIKit

class CoursesTableViewCell: UITableViewCell {

    @IBOutlet weak var courseNameLabel: UILabel!
    @IBAction func beaconSwitch(sender: AnyObject) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
