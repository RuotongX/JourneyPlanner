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
    
    var routeImage : UIImage
    var routeName : String
    var routeStayPoints : [String]
    
    init (routeImage : UIImage, routeName : String, routeStayPoints : [String]){
        self.routeImage = routeImage
        self.routeName = routeName
        self.routeStayPoints = routeStayPoints
    }
}
