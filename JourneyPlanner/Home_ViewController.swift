//
//  FirstViewController.swift
//  JourneyPlanner
//
//  Created by RuotongX on 2019/3/20.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Foundation

protocol Home_ViewControllerDelegate{
    func passOnInformation(_ controller:Home_ViewControllerDelegate, newCity city:LocationInformation)
}

class ViewController: UIViewController, CLLocationManagerDelegate {}

class Home_ViewController: ViewController{

    //Obtain the location manager, which provide the location services (Dalton 16/Apr/2019, last modified 27/Apr/2019)
    
    @IBOutlet weak var WeatherLabel: UILabel!
    @IBOutlet weak var WeatherIcon: UIImageView!
    
    var delegate: Home_ViewControllerDelegate?
    let WeatherApiKey = "d1580a5eaffdf2ae907ca97ceaff0235"
    let locationManager = CLLocationManager()
    var cityHistory : [LocationInformation]? = []
    var CurrentCity : LocationInformation?
    var selectedCity : LocationInformation?
    @IBOutlet weak var City_Name: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        self.CurrentCity = LocationInformation()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        // used to load the view, after loading, it can customize items - Dalton Chen
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        //FOR TEST USE ONLY, DELETE BEFORE SUBMIT!   27/Apr/2019
        preparetestHistoryData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationPermission()
    }
    
    // This prepare function is used to pass the value between this viewController with another ViewController Dalton 27/Apr/2019
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CurrentLocationProvider"{
            if let selectCityController = segue.destination as? SelectCityViewController{
                selectCityController.CurrentLocationInformation = self.CurrentCity
                
                if let SelectedCity = selectedCity{
                    selectCityController.selectedCity = SelectedCity
                    self.CheckWeather(_location: (self.selectedCity?.location)!)
                }
                selectCityController.cityHistory = self.cityHistory
                selectCityController.delegate = self
            }
        }
        
        if segue.identifier == "transferCityInfo"{
            if let mapNavigationviewController = segue.destination as? UINavigationController{
                let mapviewController = mapNavigationviewController.viewControllers.first as? MapViewController
                mapviewController?.selectedCity = self.CurrentCity
                
                if let selectedCity = self.selectedCity{
                    mapviewController?.selectedCity = selectedCity
                    self.CheckWeather(_location: (self.selectedCity?.location)!)
                }
                mapviewController?.delegate = self
            }
        }
    }
    
    func closeVC(){
        if(self.delegate != nil){
            self.delegate?.passOnInformation(self as! Home_ViewControllerDelegate, newCity: CurrentCity!)
        }
        self.dismiss(animated: true,completion: nil)
    }
    
    //Define a function which obtain the current location information (Dalton 16/Apr/2019)
    func locationPermission(){
        let status = CLLocationManager.authorizationStatus()
        
        //check the status of permission, if not determined,request the permission
        if status == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        
        if status == .denied || status == .restricted{
            self.present(displayLocationPermissionError(), animated: true) {
                
                self.City_Name.text = "Unknown"

                if let selectedCity = self.selectedCity{
                    self.City_Name.text = selectedCity.cityName
                    self.CheckWeather(_location: (self.selectedCity?.location)!)
                }
            }
        }
        
        if status == .authorizedWhenInUse{
            // request single location (Dalton 27/Apr/2019)
            locationManager.requestLocation()
//            locationManager.startUpdatingLocation()
            
        }
        
    }
    
    func preparetestHistoryData(){
        
        var cityList : [LocationInformation] = []
        
        let welinfo : LocationInformation = LocationInformation(cityName: "Wellington", lontitude: 174.772996908, latitude: -41.28666552, zipCode: "5010")
        let rotoruainfo : LocationInformation = LocationInformation(cityName: "Rotorua", lontitude: 176.24516, latitude: -38.13874, zipCode: "3010")
        let christChurchInfo : LocationInformation = LocationInformation(cityName: "Christchurch", lontitude: 172.639847, latitude: -43.525650, zipCode: "7670")
        let hamilton : LocationInformation = LocationInformation (cityName: "Hamilton", lontitude: 175.28333, latitude: -37.78333, zipCode: "3200")
        
        cityList.append(welinfo)
        cityList.append(rotoruainfo)
        cityList.append(christChurchInfo)
        cityList.append(hamilton)
        
        cityHistory = cityList
    }

	
    func displayLocationPermissionError() -> UIAlertController{
        let alert = UIAlertController(title: "Location Service is disabled", message: "Please enable location service at setting page", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        
        return alert
    }
    

    // obtain the city names and display it 21 Apr 2019 Dalton
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first{
            
            let geoCoder : CLGeocoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation) { (placemark, error) in
                
                if let error = error{
                    print("Unable to convert coordinates to city information")
                    print(error.localizedDescription)
                }
                
                if let placemark = placemark{
                    let locationInfo = placemark.first
                    
                    if let suburbs = locationInfo?.subLocality,
                       let postCode = locationInfo?.postalCode{
                        self.City_Name.text = "\(suburbs)"
                        
                        if let selectedCity = self.selectedCity{
                            self.City_Name.text = selectedCity.cityName
                            self.CheckWeather(_location: (self.selectedCity?.location)!)
                        }
                        
                        let location = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                        self.CurrentCity?.cityName = suburbs
                        self.CurrentCity?.location = location
                        self.CurrentCity?.zipCode = postCode
                    }
                }
            }
            CheckWeather(_location: currentLocation)
        }
    }
    // cannot obtain the current location, display error message 21 Apr 2019 Dalton
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: Unable to obtain the current location of user")
        print(error.localizedDescription)
    }
    
    // if user changed the permission authorization, it will value it again for services
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationPermission()
    }
    func CheckWeather(_location: CLLocation){
        let lat = _location.coordinate.latitude
        let lon = _location.coordinate.longitude
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(WeatherApiKey)&units=metric").responseJSON{
            response in
            if let responseStr = response.result.value{
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                var iconName = jsonWeather["icon"].stringValue
                
                
                switch iconName{
                case "01d":
                    iconName = "Home-Weather-Sunny"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "01n":
                    iconName = "Home-Weather-Sunny"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "02d":
                    iconName = "Home-Weather-Partlycloudy"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "02n":
                    iconName = "Home-Weather-Partlycloudy"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "03d":
                    iconName = "Home-Weather-Cloudy"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "03n":
                    iconName = "Home-Weather-Cloudy"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "04d":
                    iconName = "Home-Weather-Mostlycloudy"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "04n":
                    iconName = "Home-Weather-Mostlycloudy"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "09d":
                    iconName = "Home-Weather-Sunnyrain"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "09n":
                    iconName = "Home-Weather-Sunnyrain"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "10d":
                    iconName = "Home-Weather-rain"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "10n":
                    iconName = "Home-Weather-rain"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "11d":
                    iconName = "Home-Weather-Thunder"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "11n":
                    iconName = "Home-Weather-Thunder"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "13d":
                    iconName = "Home-Weather-Mostlycloudy"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "13n":
                    iconName = "Home-Weather-Mostlycloudy"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "50d":
                    iconName = "Home-Weather-Fog"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                case "50n":
                    iconName = "Home-Weather-Fog"
                    self.WeatherIcon.image = UIImage(named:iconName)
                    break;
                default:
                    break;
                }
                self.WeatherIcon.image = UIImage(named: iconName)
                
                self.WeatherLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))℃"
            }
        }
    }
}

extension Home_ViewController : SelectCityViewControllerDelegate{
    func didSelectNewCity(_ controller: SelectCityViewController, newCity city: LocationInformation, historyCity: [LocationInformation]) {
        self.cityHistory = historyCity
        self.selectedCity = city
        self.City_Name.text = self.selectedCity?.cityName
    }
}

extension Home_ViewController : MapViewControllerDelegate{
    
}


