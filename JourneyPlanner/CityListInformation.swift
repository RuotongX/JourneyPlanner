//
//  CityListInformation.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 20/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// this class is used to store the city information
class CityListInformation{
    var cityName : String
    var cityStopTime : Int
    var cityLocation : CLLocationCoordinate2D
    var cityImage : UIImage
    var Attractions : [AttractionInformation]?
    
    // default constructor
    init(name : String, time : Int, location : CLLocationCoordinate2D, image : UIImage) {
        self.cityName = name
        self.cityStopTime = time
        self.cityLocation = location
        self.cityImage = image
    }
    
    // alternative constructor
    convenience init (name : String, time : Int, location : CLLocationCoordinate2D, image : UIImage, attractions : [AttractionInformation]){
        self.init(name: name, time: time, location: location, image: image)
        self.Attractions = attractions
    }
}
