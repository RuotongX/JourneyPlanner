//
//  SelectDestinationTableViewCell.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 26/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

// this method is used to define the cell type for destination view controller
class SelectDestinationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var CityImangeDarkCover: UIImageView!
    @IBOutlet weak var CityName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
