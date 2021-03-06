//
//  ResturantCellController.swift
//  JourneyPlanner
//
//  Created by RuotongX on 2019/5/4.
//  Copyright © 2019 RuotongX. All rights reserved.
//
// This class is used to control the cell in restaurant table.
import UIKit
import Foundation
import SafariServices

class ResturantCellController: UITableViewCell {


    @IBOutlet weak var ResturantImage: UIImageView!
    @IBOutlet weak var ResturantName: UILabel!
    @IBOutlet weak var ResturantMark: UILabel!
    @IBOutlet weak var AvangeCost: UILabel!
    @IBOutlet weak var ResturantType: UILabel!
    
    
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
// This function is used to recognize which user click and pass the url information to ZomatoWeb view to display the website.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UserDefaults().set(self.Url,forKey: "ZomatoUrl")
        // Configure the view for the selected state
    }
    


}
