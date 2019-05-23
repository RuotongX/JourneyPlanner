//
//  AttractionDetailTableViewCell.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 23/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class AttractionDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var DarkCoverforImage: UIImageView!
    @IBOutlet weak var AttractionImage: UIImageView!
    
    @IBOutlet weak var AttractionName: UILabel!
    @IBOutlet weak var AttractionAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        AttractionImage.layer.cornerRadius = 8
        DarkCoverforImage.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
