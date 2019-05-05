//
//  PlanInformation.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 23/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import Foundation
import CoreLocation

// this class will stores the trip information, which will be used on the trip detail information section - dalton 23/04/2019
class SmallTripInformation{
    var name:String
    var location : CLLocation
    var staylength : Int
    var arragement : Int
    
    var memo : String?
    var rating : Double?
    var recommendStayLength : Int?
    
    // this is the default contrustor for this type of item - dalton 23/04/2019
    init(name:String,location:CLLocation, staylength: Int,arrangement : Int) {
        self.name = name
        self.location = location
        self.staylength = staylength
        self.arragement = arrangement
    }
    
}
