//
//  PlanInformations.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 20/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import Foundation

// this class is used to store the plan information
class PlanInformations{
    var planName : String
    var City : [CityListInformation]
    var memo : String
    
    // default constructor
    init(name : String, citylist : [CityListInformation], memo : String) {
        self.planName = name
        self.City = citylist
        self.memo = memo
    }
}
