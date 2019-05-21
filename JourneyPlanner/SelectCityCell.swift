//
//  SelectCityCell.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 21/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class SelectCityCell: UITableViewCell {

    @IBOutlet weak var imagePath: UIImageView!
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
