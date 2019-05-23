//
//  PlanInformations.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 20/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import Foundation

class PlanInformations{
    var planName : String
    var City : [CityListInformation]
    var memo : String
    
    init(name : String, citylist : [CityListInformation], memo : String) {
        self.planName = name
        self.City = citylist
        self.memo = memo
    }
}
