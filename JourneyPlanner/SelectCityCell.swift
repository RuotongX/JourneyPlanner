//
//  SelectCityCell.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 24/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class SelectCityCell: UITableViewCell {
    
    //Create two empty function that can be accessed in view controller page - ZHE WANG
    var IncreaseButton : (() -> ()) = {}
    var DecreaseButton : (() -> ()) = {}

    @IBOutlet weak var CityImage: UIImageView!
    
    @IBOutlet weak var CityNmae: UILabel!
    
    @IBOutlet weak var TimeLabel: UILabel!
    
    @IBOutlet weak var Background: UIImageView!
    
    @IBAction func TimeIncrease(_ sender: UIButton) {
        
        IncreaseButton()
    }
    
    @IBAction func TimeDecrease(_ sender: Any) {
        
        DecreaseButton()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
