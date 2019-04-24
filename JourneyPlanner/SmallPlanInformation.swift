//
//  PlanInformation.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 23/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import Foundation
import CoreLocation

class SmallPlanInformation{
    var name:String
    var location : CLLocation
    var staylength : Int
    var arragement : Int
    
    var memo : String?
    var rating : Double?
    var recommendStayLength : Int?
    
    init(name:String,location:CLLocation, staylength: Int,arrangement : Int) {
        self.name = name
        self.location = location
        self.staylength = staylength
        self.arragement = arrangement
    }
    
}
