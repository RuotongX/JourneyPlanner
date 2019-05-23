//
//  SelectAttractionCell.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 23/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class SelectAttractionCell: UITableViewCell {
    
    @IBOutlet weak var AttractionImage: UIImageView!
    
    @IBOutlet weak var AttractionName: UILabel!
    
    @IBOutlet weak var Background: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
