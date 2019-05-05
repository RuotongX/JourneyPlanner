//
//  CityGuideInfo.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 18/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import Foundation

// this method id defined the city guide type, which it have 4 types - Dalton 18/04/2019
enum cityGuideType{
    case FOOD
    case HOTEL
    case LANDSCAPE
    case UNKNOWN
}

// set up the city guide informaiton - Dalton 18/04/2019
class cityGuideDetail {
    var short_intro : String
    var title : String
    var type : cityGuideType
    var address : String
    var rate : Float
    var description : String
    var city : String
    var individualKey : Int
    
    // default constructor - Dalton 18/04/2019
    init(Short_Desc : String, title :String, type : cityGuideType, address:String, rate :Float, description : String,
         city:String, individualKey : Int){
        self.short_intro = Short_Desc
        self.title = title
        self.type = type
        self.address = address
        self.rate = rate
        self.description = description
        self.city = city
        self.individualKey = individualKey
    }
    
    // alternative contruction - Dalton 18/04/2019
    convenience init(){
        self.init(Short_Desc: "Short Intro", title: "Title", type: cityGuideType.UNKNOWN, address: "Address", rate: 5, description: "Description", city: "City", individualKey: 00000)
    }
}
