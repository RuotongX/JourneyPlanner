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
//        let realm = try! Realm()
//        let routeInformationDB = realm.objects(RouteInformation_Database.self)
//
//
//        try! realm.write {
//            realm.delete(routeInformationDB)
//            print(Realm.Configuration.defaultConfiguration.fileURL)
//        }

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
        
        
        let path = Bundle.main.path(forResource: "CityInformation", ofType: "plist")!
        let cityArray = NSArray(contentsOfFile: path)!

        print(cityArray.count)
        
        for cityDict in cityArray{
            let info = cityDict as! NSDictionary
            
            print(info["cityName"])
        }
        
        
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
