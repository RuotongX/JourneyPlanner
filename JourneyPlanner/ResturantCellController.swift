//
//  ResturantCellController.swift
//  JourneyPlanner
//
//  Created by RuotongX on 2019/5/4.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class ResturantCellController: UITableViewCell {

    
    @IBOutlet weak var ResturantImage: UIImageView!
    @IBOutlet weak var ResturantName: UILabel!
    @IBOutlet weak var ResturantMark: UILabel!
    @IBOutlet weak var AvangeCost: UILabel!
    @IBOutlet weak var ResturantType: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func ResturantLocation(_ sender: Any) {
    }
}
