//
//  CuisineCell.swift
//  JourneyPlanner
//
//  Created by RuotongX on 2019/5/11.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class CuisineCell: UITableViewCell {
    @IBOutlet weak var CuisinePicture: UIImageView!
    @IBOutlet weak var CuisineName: UILabel!
    @IBOutlet weak var ShowIndicator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
