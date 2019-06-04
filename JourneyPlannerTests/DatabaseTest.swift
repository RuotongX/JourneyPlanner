//
//  DatabaseTest.swift
//  JourneyPlannerTests
//
//  Created by Dalton Chen on 4/06/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import XCTest
import CoreLocation
@testable import JourneyPlanner

class DatabaseTest: XCTestCase {

    
    var cityInformation : [CityListInformation] = []
    
    override func setUp() {

        loadCityInformation()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        XCTAssertEqual(cityInformation.count, 13)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        
    
        self.measure {
            
        }
    }

    func loadCityInformation(){
        
        // load from bundle (left hand side)
        let plistPath = Bundle.main.path(forResource: "CityInformation", ofType: "plist")!
        let cityList = NSArray(contentsOfFile: plistPath)!
        
        
        //Choice which data need to load
        for cityDict in cityList{
            
            let cityInfo = cityDict as! NSDictionary
            
            let cityName = cityInfo["cityName"] as! String
            let cityStopTime = cityInfo["cityStopTime"] as! Int
            let cityLocation_Lon = cityInfo["cityLocation_lon"] as! Double
            let cityLocation_lat = cityInfo["cityLocation_lat"] as! Double
            let cityImageName = cityInfo["cityImage_Name"] as! String
            
            //Write the data to our data constructor that can easy transfer to the sub class by protocol - ZHE WANG
            //Also include the analyzing conditions that determine wheather the data compare to the user selected. - ZHE WANG
            if let cityImage = UIImage(named: cityImageName){
                
                let city = CityListInformation(name: cityName, time: cityStopTime, location: CLLocationCoordinate2D(latitude: cityLocation_lat, longitude: cityLocation_Lon), image: cityImage)
                cityInformation.append(city)
            } else {
                
                if let defaultImage = UIImage(named: "City-default"){
                    let city = CityListInformation(name: cityName, time: cityStopTime, location: CLLocationCoordinate2D(latitude: cityLocation_lat, longitude: cityLocation_lat), image: defaultImage)
                    cityInformation.append(city)
                }
            }
        }
        
    }
}
