//
//  TripPlan.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 23/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import Foundation
import CoreLocation

class TripPlan{
    
    var trips : [SmallPlanInformation] = []
    var firstCity : CityInformation
    var distances : Double
    var PlanName : String
    
    init(trips : [SmallPlanInformation], firstCity : CityInformation, distances: Double, PlanName:String) {
        self.trips = trips
        self.firstCity = firstCity
        self.distances = distances
        self.PlanName = PlanName
    }
    
    func addTrip(trip : SmallPlanInformation){
        self.trips.append(trip)
    }


}

