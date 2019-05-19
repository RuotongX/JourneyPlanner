//
//  PlanDetailInformation.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 20/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import Foundation
import UIKit

class PlanDetailInformation{
    var City : [CityListInformation]
    var memo : String
    
    init(citylist : [CityListInformation], memo : String) {
        self.City = citylist
        self.memo = memo
    }
}
