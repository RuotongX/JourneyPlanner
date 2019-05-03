//
//  Resturant.swift
//  JourneyPlanner
//
//  Created by RuotongX on 2019/5/4.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class Resturant {
    var RImage : UIImage
    var RName : String
    var RMark : String
    var RType : String
    var RCost : String
    var Rlat : String
    var Rlon : String
    
    init(){
        self.RImage = UIImage(named: "Home-Weather-Cloudy")!
        self.RName = "DoubleHappy"
        self.RMark = "3.5"
        self.RType = "Chinese"
        self.RCost = "20"
        self.Rlat = "-36.7186265"
        self.Rlon = "174.7169448"
    }
    
}
