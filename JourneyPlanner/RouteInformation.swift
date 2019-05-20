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
    
    init (name : String, time : Int, image : UIImage){
        self.routeName = name
        self.routeStopTime = time
        self.routeImage = image
    }
}
