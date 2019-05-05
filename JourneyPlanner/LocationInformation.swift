//
//  City.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 21/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//
// This class is storing the location information 21/04/2019 dalton
import Foundation
import CoreLocation

// this class is all about the location information. 21/04/2019 dalton
class LocationInformation{
    var cityName : String
    var location : CLLocation
    var zipCode : String
    
    // an default constructor which used to initial the class 21/04/2019 dalton
    init(cityName:String, lontitude:Double, latitude:Double, zipCode:String) {
        self.cityName = cityName
        self.location = CLLocation(latitude: latitude, longitude: lontitude)
        self.zipCode = zipCode
    }
    
    // the alternative contructor which could build this class 21/04/2019 dalton
    convenience init(){
        self.init(cityName: "Unknown", lontitude: 0.00, latitude: 0.00, zipCode: "0000")
    }
}
