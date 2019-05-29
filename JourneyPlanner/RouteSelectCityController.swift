//
//  SelectCirtyController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 24/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

protocol RouteSelectCityControllerDelgate {
    
}

class RouteSelectCityController: UIViewController {
    
    
    @IBAction func ReturnButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    var delgate : RouteSelectCityControllerDelgate?
    var cityInformation : [CityListInformation] = []
    
    @IBOutlet weak var SelectCityTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCityInformation()

        SelectCityTableview.dataSource = self
        SelectCityTableview.delegate = self
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    private func loadCityInformation(){
        
        // load from bundle (left hand side)
        let plistPath = Bundle.main.path(forResource: "CityInformation", ofType: "plist")!
        let cityList = NSArray(contentsOfFile: plistPath)!
        
        cityInformation = []
        
        for cityDict in cityList{
            
            let cityInfo = cityDict as! NSDictionary
            
            let cityName = cityInfo["cityName"] as! String
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AttractionData"{
            if let selsectAttraction = segue.destination as? RouteAttractionController{
                selsectAttraction.delgate = self
                
                if let cell = sender as? UITableViewCell{
                    if let indexPath = SelectCityTableview.indexPath(for: cell){
                        if let attraction = cityInformation[indexPath.row].Attractions{
                            selsectAttraction.AttractionData = attraction
                        }
                    }
                }
            }
        }
    }
}

extension RouteSelectCityController : UITableViewDelegate, UITableViewDataSource, RouteAttractionControllerDelgate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCityCell", for: indexPath) as? RouteSelectCityCell else {
            fatalError("The dequeued cell is not an instance of SelectCityTableviewCellTableViewCell.")
        }
        
        cell.CityNmae.text = cityInformation[indexPath.row].cityName
        
        cell.CityImage.image = cityInformation[indexPath.row].cityImage
        
        cell.TimeLabel.text = String(cityInformation[indexPath.row].cityStopTime)
        
        cell.CityImage.layer.cornerRadius = 8
        cell.Background.layer.cornerRadius = 8
//        cell.DarkCoverForImage.layer.cornerRadius = 8
        
        //Define the empty function taht used to set tha action for the increase button - ZHE WANG
        cell.IncreaseButton = {
            
            let impactFeedBackGenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedBackGenerator.prepare()
            impactFeedBackGenerator.impactOccurred()
            
            self.cityInformation[indexPath.row].cityStopTime = self.cityInformation[indexPath.row].cityStopTime + 1
            cell.TimeLabel.text = String(self.cityInformation[indexPath.row].cityStopTime)
            
        }
        
        cell.DecreaseButton = {
            
            if self.cityInformation[indexPath.row].cityStopTime > 1{
                let impactFeedBackGenerator = UIImpactFeedbackGenerator(style: .light)
                impactFeedBackGenerator.prepare()
                impactFeedBackGenerator.impactOccurred()
                
                self.cityInformation[indexPath.row].cityStopTime = self.cityInformation[indexPath.row].cityStopTime - 1
                cell.TimeLabel.text = String(self.cityInformation[indexPath.row].cityStopTime)
            } else{
                let error = UINotificationFeedbackGenerator()
                error.notificationOccurred(.error)
            }
        }
        
        return cell
    }
}
