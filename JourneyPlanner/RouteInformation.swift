//
//  RouteInformation.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 13/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

//Define the data type of route informaiton
import Foundation
import UIKit
// this method is used to store the route information
class RouteInformation{
    
    var routeName : String
    var routeStopTime : Int
    var routeImage : UIImage
    var Cities : [CityListInformation]?
    var CitieName : [String]?
    
    // default constructor
    init (name : String, time : Int, image : UIImage){
        self.routeName = name
        self.routeStopTime = time
        self.routeImage = image
    }
    
    // alternative constructor
    convenience init(name : String, time : Int, image : UIImage, city : [CityListInformation]){
        self.init(name: name, time: time, image: image)
        self.Cities = city
    }
}
