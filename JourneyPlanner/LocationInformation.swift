//
//  City.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 21/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//
// This class is storing the location information
import Foundation
import CoreLocation

class LocationInformation{
    var cityName : String
    var location : CLLocation
    var zipCode : String
    
    init(cityName:String, lontitude:Double, latitude:Double, zipCode:String) {
        self.cityName = cityName
        self.location = CLLocation(latitude: latitude, longitude: lontitude)
        self.zipCode = zipCode
    }
    
    convenience init(){
        self.init(cityName: "Unknown", lontitude: 0.00, latitude: 0.00, zipCode: "0000")
    }
}
