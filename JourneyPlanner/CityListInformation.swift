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

class CityListInformation{
    var cityName : String
    var cityStopTime : Int
    var cityLocation : CLLocationCoordinate2D
    var cityImage : UIImage
    var Attractions : [AttractionInformation]?
    
    init(name : String, time : Int, location : CLLocationCoordinate2D, image : UIImage) {
        self.cityName = name
        self.cityStopTime = time
        self.cityLocation = location
        self.cityImage = image
    }
}
