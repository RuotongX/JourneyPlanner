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

class AttractionInformation_Database : Object{
    @objc dynamic var AttractionName : String = ""
    @objc dynamic var AttractionLocation_Lan : Double = 0.0
    @objc dynamic var AttractionLocation_Lon : Double = 0.0
    @objc dynamic var AttractionImg : String = ""
}

class CityInformation_Database : Object {
    @objc dynamic var CityName : String = ""
    @objc dynamic var StopTime : Int = 0
    @objc dynamic var CityLocation_Lon : Double = 0.0
    @objc dynamic var CityLocation_Lat : Double = 0.0
    @objc dynamic var CityImgName : String = ""
    let attractionList = List<AttractionInformation_Database>()
}

class PlanInformation_Database : Object{
    @objc dynamic var PlanName : String = ""
    @objc dynamic var PlanMemo : String = ""
    let cities = List<CityInformation_Database>()
}
