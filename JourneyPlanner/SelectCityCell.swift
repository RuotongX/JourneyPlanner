//
//  SelectCityCell.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 21/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class SelectCityCell: UITableViewCell {
    
    //set an empty function that can access in selecCity controller - ZHE WANG
    var IncreaseButton : (() -> ()) = {}
    var DecreaseButton : (() -> ()) = {}

    @IBOutlet weak var imagePath: UIImageView!
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var DaysTIme: UILabel!
    
    @IBAction func TimeIncrease(_ sender: UIButton) {
        IncreaseButton()
    }
    
    @IBAction func TimeDecrease(_ sender: UIButton) {
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
