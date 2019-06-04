//
//  RoutePreviewCell.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 24/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class RoutePreviewCell: UITableViewCell {
    
    // this class is used to define the plan priview table view cell, it contains some necessary information for a cell - ZHE WANG
    
    @IBOutlet weak var PreviewImage: UIImageView!
    @IBOutlet weak var DarkCover: UIImageView!
    @IBOutlet weak var PreviewName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
