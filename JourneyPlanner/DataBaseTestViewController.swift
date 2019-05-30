//
//  DataBaseTestViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 28/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class DataBaseTestViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let cityName = Cities_Name()
//        cityName.cities_Name = "CityName"
//
//        let testRouteInfo = RouteInformation_Database()
//        testRouteInfo.routeName = "Route Name"
//        testRouteInfo.routeStopTime = 5
//        testRouteInfo.routeImageName = "Route Image"
//        testRouteInfo.citie_names.append(cityName)
//
        
        let attraction = AttractionInformation_Database()
        attraction.AttractionName = "Attraction"
        attraction.AttractionLocation_Lan = 1.234
        attraction.AttractionLocation_Lon = 5.678
        attraction.AttractionImg = "Attraction IMG"
        
        let city = CityInformation_Database()
        city.CityName = "City"
        city.StopTime = 1
        city.CityLocation_Lat = 11.2222
        city.CityLocation_Lon = 22.1111
        city.CityImgName = "city IMG"
        city.attractionList.append(attraction)
        
        let plan = PlanInformation_Database()
        plan.PlanName = "Plan"
        plan.PlanMemo = "Memo"
        plan.cities.append(city)
        
        let plan2 = PlanInformation_Database()
        plan2.PlanName = "Plan2"
        plan2.PlanMemo = "Memo2"
        plan2.cities.append(city)
        
        
        let realm = try! Realm()
        let planDB = realm.objects(PlanInformation_Database.self)
        let attractionDB = realm.objects(AttractionInformation_Database.self)
        let cityDB = realm.objects(CityInformation_Database.self)

        try! realm.write {
            realm.delete(planDB)
            realm.delete(attractionDB)
            realm.delete(cityDB)
            realm.add(plan)
            realm.add(plan2)
            
//            print(Realm.Configuration.defaultConfiguration.fileURL)
        }

//        let array = NSArray(objects: "hangge.com","baidu.com","google.com","163.com","qq.com")
//        let filePath:String = NSHomeDirectory() + "/Documents/webs.plist"
//        array.write(toFile: filePath, atomically: true)
//        print(filePath)

//        var webs:NSArray?
//
//        webs = NSArray(contentsOfFile:  NSHomeDirectory() + "/Documents/webs.plist")
//
//        let data = webs![0] as! String
//        print(data)
        
        // Do any additional setup after loading the view.
        
        
//        let path = Bundle.main.path(forResource: "CityInformation", ofType: "plist")!
//        let cityArray = NSArray(contentsOfFile: path)!
//
//        print(cityArray.count)
//
//        for cityDict in cityArray{
//            let info = cityDict as! NSDictionary
//
//            print(info["cityName"])
//        }
        
        
//        let dt = dict?[0] as! Array<AnyObject>
//        print(dt.count)
        
//        let data = dict?[0] as! Array<AnyObject>
//        let cityName = data[0]["cityName"] as! String
//        print(cityName)
        
        
    }
    

    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
