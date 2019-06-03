//
//  PlanDetailStayLengthTableViewCell.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 23/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

// this method is used to control the content inside tableview cell, this one is for the stay length
class PlanDetailStayLengthTableViewCell: UITableViewCell {

    @IBOutlet weak var StayLength: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
