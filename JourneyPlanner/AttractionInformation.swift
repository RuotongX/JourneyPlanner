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

// this class is used to define the attraction information
class AttractionInformation{
    var attractionName : String
    var attractionLocation : CLLocationCoordinate2D
    var attractionImage : UIImage?
    var attractionImageName : String?
    var isSelectedFromPage : Bool = false
    
    //default constructor
    init(Name : String, Location : CLLocationCoordinate2D) {
        self.attractionName = Name
        self.attractionLocation = Location
    }
    
    // alternative constructor
    convenience init(Name : String, Location : CLLocationCoordinate2D, attractionImage :UIImage){
        self.init(Name: Name, Location: Location)
        self.attractionImage = attractionImage
    }
}
