//
//  SelectCityInformation_Database.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 28/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import Foundation
import RealmSwift

class SelectCityInformation_Database : Object{
    @objc dynamic var cityName : String = ""
    @objc dynamic var cityZipCode : String = ""
    @objc dynamic var cityLocation_Latitude : Double = 0.0
    @objc dynamic var cityLocation_Longitude : Double = 0.0
}

class Cities_Name : Object{
    @objc dynamic var cities_Name : String = ""
}

class RouteInformation_Database : Object{
    @objc dynamic var routeName : String = ""
    @objc dynamic var routeStopTime : Int = 0
    @objc dynamic var routeImageName : String = ""
    let citie_names = List<Cities_Name>()
}
