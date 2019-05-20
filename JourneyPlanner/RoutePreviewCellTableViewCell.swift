//
//  RoutePreviewCellTableViewCell.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 20/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class RoutePreviewCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var AttractionsImage: UIImageView!
    
    @IBOutlet weak var AttractionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
