//
//  PlanCityTableViewCell.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 22/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class PlanCityTableViewCell: UITableViewCell {
    
    // this class is used to define the plan city table view cell, it contains some necessary information for a cell
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var CityNameLabel: UILabel!
    @IBOutlet weak var City_BackgroundImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
