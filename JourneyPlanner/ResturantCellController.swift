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
    @IBOutlet weak var Rank: UILabel!
    
    
    var Url :String = ""
    var lat : Double = 0.0
    var lon : Double = 0.0
    
    func setResturant(resturant:Resturant){
        ResturantImage.image = resturant.RImage
        ResturantName.text = resturant.RName
        ResturantMark.text = resturant.RMark
        AvangeCost.text = "$ "+"\(resturant.RCost)"
        ResturantType.text = resturant.RType
        self.Url = resturant.RUrl
        self.lat = resturant.Rlat
        self.lon = resturant.Rlon
        self.Rank.text = "\(resturant.Rank)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    @IBAction func ResturantLocation(_ sender: Any) {
//    }
}
