//
//  TripPlan.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 23/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import Foundation
import CoreLocation

// this class is used to provide infromation for the trip plan - Dalton 23/04/2019
class TripPlan{
    
    // one plan can have multiple trips, but there is only one first goto city - Dalton 23/04/2019
    var trips : [SmallTripInformation] = []
    var firstCity : LocationInformation
    var distances : Double
    var PlanName : String
    
    // the default constructor which holds the value and create a new plan - Dalton 23/04/2019
    init(trips : [SmallTripInformation], firstCity : LocationInformation, distances: Double, PlanName:String) {
        self.trips = trips
        self.firstCity = firstCity
        self.distances = distances
        self.PlanName = PlanName
    }
    
    
    // this function is used to add the trip to the current plan - Dalton 23/04/2019
    func addTrip(trip : SmallTripInformation){
        self.trips.append(trip)
    }
    
    // this function is used to move the item from one place to other place on the tableview (reorder)  - Dalton 23/04/2019
    func move(item: SmallTripInformation, to index: Int, source sourceIndex:Int){
        trips.remove(at: sourceIndex)
        trips.insert(item, at: index)
        
        for index in 0..<trips.count{
            trips[index].arragement = index + 1
        }
    }


}

