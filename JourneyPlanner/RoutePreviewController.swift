//
//  RoutePreviewController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 24/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

protocol nameRoutePreviewControllerDelgate {
    
}

class RoutePreviewController: UIViewController {

    @IBOutlet weak var RoutePreviewTableview: UITableView!
    
    var delgate: nameRoutePreviewControllerDelgate?
    var routeName : String?
    var cityName : [String]?
    var cityInformation : [CityListInformation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RoutePreviewTableview.dataSource = self
        RoutePreviewTableview.delegate = self
        
        loadCityInformation()
    }
    
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

extension RoutePreviewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoutePreviewCell", for: indexPath) as? RoutePreviewCell else {fatalError("The dequeued cell is not an instance of RoutePreviewCellTableViewCell")
        }
        
        cell.PreviewName.text = cityInformation[indexPath.row].cityName
        
        cell.PreviewImage.image = cityInformation[indexPath.row].cityImage
        
        cell.PreviewImage.layer.cornerRadius = 8
        cell.DarkCover.layer.cornerRadius = 8

        return cell
    }
}
