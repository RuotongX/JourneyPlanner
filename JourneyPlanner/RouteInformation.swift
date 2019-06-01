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
class RouteInformation{
    
    var routeName : String
    var routeStopTime : Int
    var routeImage : UIImage
    var Cities : [CityListInformation]?
    var CitieName : [String]?
    
    init (name : String, time : Int, image : UIImage){
        self.routeName = name
        self.routeStopTime = time
        self.routeImage = image
    }
    
    convenience init(name : String, time : Int, image : UIImage, city : [CityListInformation]){
        self.init(name: name, time: time, image: image)
        self.Cities = city
    }
}
