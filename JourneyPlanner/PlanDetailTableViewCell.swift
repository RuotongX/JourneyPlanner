//
//  PlanDetailTableViewCell.swift
//  JourneyPlanner
//
//  Created by Wanfang Zhou on 25/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

// this class is used to define the view table cell information - Wanfang Zhou  25/04/2019
class PlanDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var LocationNameLabel: UILabel!
    @IBOutlet weak var StreetLabel: UILabel!
    @IBOutlet weak var MemoLabel: UILabel!
    @IBOutlet weak var StayLengthLabel: UILabel!
    @IBOutlet weak var SequenceNumber: UILabel!
    
    // as same as the viewdidload, it will called when it loaded - Wanfang Zhou  25/04/2019
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // when user select it , it will give the super class notice - Wanfang Zhou  25/04/2019
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
