//
//  RoutePreviewController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 24/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

//Protocol which using to transfer the data for his superior class - ZHE WANG
protocol nameRoutePreviewControllerDelgate {
    
}

class RoutePreviewController: UIViewController {

    @IBOutlet weak var RoutePreviewTableview: UITableView!
    
    //Delgate that used to connect the protocol from Select Route Controller - ZHE WANG
    var delgate: nameRoutePreviewControllerDelgate?
    
    //Necessary materials for the Select Route
    var routeName : String?
    var cityName : [String]?
    var cityInformation : [CityListInformation] = []

    // when user open the software, this viewdidload will be automatically called
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RoutePreviewTableview.dataSource = self
        RoutePreviewTableview.delegate = self
        
        loadCityInformation()
    }
    
    //Load data method, that will connect and receive the data from Properity List - ZHE WANG
    private func loadCityInformation(){
        
        // load from bundle (left hand side)
        let plistPath = Bundle.main.path(forResource: "CityInformation", ofType: "plist")!
        let cityList = NSArray(contentsOfFile: plistPath)!
        
        cityInformation = []
        
        for cityDict in cityList{
            
            let cityInfo = cityDict as! NSDictionary
            
            let cityName = cityInfo["cityName"] as! String
            
            if let selectedCity = self.cityName{
                for city in selectedCity{
                    if cityName == city{
                        
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
        }
    }
}

//inherence UITableview delgate and data source
//Inclues the paramters setting on UI page - ZHE WANG
extension RoutePreviewController : UITableViewDataSource, UITableViewDelegate{
    
    //Return the number of cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityInformation.count
    }
    
    //Reuseable - set reuseable function for the cell
    //Only need to create one cell, other row will reuse the first cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoutePreviewCell", for: indexPath) as? RoutePreviewCell else {fatalError("The dequeued cell is not an instance of RoutePreviewCellTableViewCell")
        }
        
        //Set the content paramters for the items on select city page.
        cell.PreviewName.text = cityInformation[indexPath.row].cityName
        
        cell.PreviewImage.image = cityInformation[indexPath.row].cityImage
        
        //Set the laybout paramters for the items on select city page.
        cell.PreviewImage.layer.cornerRadius = 8
        cell.DarkCover.layer.cornerRadius = 8

        return cell
    }
}
