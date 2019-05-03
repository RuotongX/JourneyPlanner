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
    
    var trips : [SmallTripInformation] = []
    var firstCity : LocationInformation
    var distances : Double
    var PlanName : String
    
    init(trips : [SmallTripInformation], firstCity : LocationInformation, distances: Double, PlanName:String) {
        self.trips = trips
        self.firstCity = firstCity
        self.distances = distances
        self.PlanName = PlanName
    }
    
    func addTrip(trip : SmallTripInformation){
        self.trips.append(trip)
    }
    
    func move(item: SmallTripInformation, to index: Int, source sourceIndex:Int){
        trips.remove(at: sourceIndex)
        trips.insert(item, at: index)
        
        for index in 0..<trips.count{
            trips[index].arragement = index + 1
        }
    }


}

