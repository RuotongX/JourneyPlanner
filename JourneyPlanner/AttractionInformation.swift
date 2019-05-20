//
//  AttractionInformation.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 20/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AttractionInformation{
    var attractionName : String
    var attractionLocation : CLLocationCoordinate2D
    var attractionImage : UIImage
    
    init(Name : String, Location : CLLocationCoordinate2D, Image : UIImage) {
        self.attractionName = Name
        self.attractionLocation = Location
        self.attractionImage = Image
    }
}
