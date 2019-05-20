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
    var smallPlan : [PlanDetailInformation]
    
    init(name : String, smallPlan : [PlanDetailInformation]) {
        self.planName = name
        self.smallPlan = smallPlan
    }
}
