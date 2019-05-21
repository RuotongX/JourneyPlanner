//
//  PlanTableViewCell.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 24/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

// this is the class which customize the plan table view cell, it is the cell. - Dalton 24/04/2019
class PlanTableViewCell: UITableViewCell {

    
    // this class contains three different labels which will be used on the cell - Dalton 24/04/2019
    @IBOutlet weak var planNameLabel: UILabel!    
    @IBOutlet weak var dayDurationLabel: UILabel!
    @IBOutlet weak var CitiesLabel: UILabel!
    // this method is equivelent as the viewdidload information
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // when this cell is being selected, display the revelent information in the super class - Dalton 24/04/2019
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
