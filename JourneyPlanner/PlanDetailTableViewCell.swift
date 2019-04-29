//
//  PlanDetailTableViewCell.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 28/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class PlanDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var LocationNameLabel: UILabel!
    @IBOutlet weak var StreetLabel: UILabel!
    @IBOutlet weak var MemoLabel: UILabel!
    @IBOutlet weak var StayLengthLabel: UILabel!
    @IBOutlet weak var SequenceNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
