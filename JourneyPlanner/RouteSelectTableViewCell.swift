//
//  RouteSelectTableViewCell.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 12/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

//Cell controller which to set up the edit for the cells - ZHE WANG
class RouteSelectTableViewCell: UITableViewCell {

    // this class is used to define the plan city table view cell, it contains some necessary information for a cell - ZHE WANG
    
    @IBOutlet weak var BlackCover: UIImageView!
    //Only connect the elements that need to do the action later
    //Connect to the image
    @IBOutlet weak var Auckland_Explore: UIImageView!
    //Connect to the label
    @IBOutlet weak var RouteName: UILabel!
    //Connect to the return button
    @IBOutlet weak var StopPointList: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //Determine whether this item has been selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    
}
