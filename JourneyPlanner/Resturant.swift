//
//  Resturant.swift
//  JourneyPlanner
//
//  Created by RuotongX on 2019/5/4.
//  Copyright © 2019 RuotongX. All rights reserved.
//
// this class is the model for restaurant.
import UIKit

class Resturant {
    var RImage : UIImage
    var RName : String
    var RMark : String
    var RType : String
    var RCost : Double
    var Rlat : Double
    var Rlon : Double
    var RUrl : String
    var Rank : Int
    var votes: Int = 0;
    // Default constructor.
    init(){
        self.RImage = UIImage(named: "zomato")!
        self.RName = "SAMRTX123"
        self.RMark = "3.5"
        self.RType = "Chinese"
        self.RCost = 20
        self.Rlat = -36.7186265
        self.Rlon = 174.7169448
        self.RUrl = "https://www.zomato.com/new-york-city/lombardis-pizza-lower-east-side?utm_source=api_basic_user&utm_medium=api&utm_campaign=v2.1"
        self.Rank = 10
        self.votes = 0;
    }
    
}
