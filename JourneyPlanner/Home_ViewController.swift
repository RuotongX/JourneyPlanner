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



class ViewController: UIViewController, CLLocationManagerDelegate {}

class Home_ViewController: ViewController{

    //Obtain the location manager, which provide the location services (Dalton 16/Apr/2019, last modified 27/Apr/2019)
    @IBOutlet weak var WeatherLabel: UILabel!
    @IBOutlet weak var WeatherIcon: UIImageView!
    
    let WeatherApiKey = "d1580a5eaffdf2ae907ca97ceaff0235"
    let locationManager = CLLocationManager()
    var cityHistory : [LocationInformation]? = []
    var CurrentCity : LocationInformation?
    var selectedCity : LocationInformation?
    @IBOutlet weak var City_Name: UILabel!
    
    //Below is set upt he current city information items Dalton 24/Apr/2019
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
    
    // after the viewdidload, this one is incharge, the alert will show in this section, other section will cause failer - Dalton 25/Apr/2019
    override func viewDidAppear(_ animated: Bool) {
        locationPermission()
    }
    
    // This prepare function is used to pass the value between this viewController with another ViewController Dalton 27/Apr/2019
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check main.storyboard and segue for more information, when the destination mathces our requirement we will passing the data to that view controller 28/Apr/2019
        if segue.identifier == "CurrentLocationProvider"{
            if let selectCityController = segue.destination as? SelectCityViewController{
                selectCityController.CurrentLocationInformation = self.CurrentCity
                
                // if user have select a city rather than using current city, it will let the subview controller know Dalton 27/Apr/2019
                if let SelectedCity = selectedCity{
                    selectCityController.selectedCity = SelectedCity
                    self.CheckWeather(_location: (self.selectedCity?.location)!)
                }
                selectCityController.cityHistories = self.cityHistory
                // set up the delegate is used to passing the value between target and this class Dalton 27/Apr/2019
                selectCityController.delegate = self
            }
        }
        
        if segue.identifier == "transferCityInfo"{
            // the mapview controller got a navigation controller which helps to handle the search request Dalton 28/Apr/2019
            // therefore if we'd likely to access the mapview, we need to obtain it from the navigation controller Dalton 29/Apr/2019
            if let mapNavigationviewController = segue.destination as? UINavigationController{
                let mapviewController = mapNavigationviewController.viewControllers.first as? MapViewController
                mapviewController?.homePage_CurrentOrSelectedCity = self.CurrentCity
                
                if let selectedCity = self.selectedCity{

                    mapviewController?.homePage_CurrentOrSelectedCity = selectedCity
                    
                    self.CheckWeather(_location: (self.selectedCity?.location)!)
                }
                mapviewController?.mapsource = .HOMEPAGE_MAP
                mapviewController?.delegate = self
            }
        }
    }
    
    
    //Define a function which obtain the current location information (Dalton 19/Apr/2019)
    func locationPermission(){
        let status = CLLocationManager.authorizationStatus()
        
        //check the status of permission, if not determined,request the permission
        if status == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        
        // if user does not provide the location or not authrolized, it will display the error information for user Dalton 20/Apr/2019
        if status == .denied || status == .restricted{
            self.present(displayLocationPermissionError(), animated: true) {
                
                self.City_Name.text = "Unknown"

                // when user have selected city, it will display the selected information 20/Apr/2019
                if let selectedCity = self.selectedCity{
                    self.City_Name.text = selectedCity.cityName
                    self.CheckWeather(_location: (self.selectedCity?.location)!)
                }
            }
        }
        
        // when user is providing the location information, keep process it
        if status == .authorizedWhenInUse{
            // request single location (Dalton 27/Apr/2019)
            locationManager.requestLocation()
//            locationManager.startUpdatingLocation()
            
        }
        
    }
    
    // this method is used to load history data for the testing purposes Dalton 23/Apr/2019
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

	
    // if user does not give the permission to the map project, it will display relevant error message to the user to ask them to provide this authrization dalton 23/Apr/2019
    func displayLocationPermissionError() -> UIAlertController{
        let alert = UIAlertController(title: "Location Service is disabled", message: "Please enable location service at setting page", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        
        return alert
    }
    

    // obtain the city names and display it 21 Apr 2019 Dalton
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first{
            
            // geocoder is provided by the apple API to allow conversion between CLplackmark and street level information - Dalton 21/Apr/2019
            let geoCoder : CLGeocoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation) { (placemark, error) in
                
                if let error = error{
                    print("Unable to convert coordinates to city information")
                    print(error.localizedDescription)
                }
                
                // if we were successfully have the placemark obtained, we will convert it to the location information, which contain several address information - Dalton 21/Apr/2019
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
    
    // weather calling api
    func CheckWeather(_location: CLLocation){
        let lat = _location.coordinate.latitude
        let lon = _location.coordinate.longitude
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(WeatherApiKey)&units=metric").responseJSON{
            response in
            if let responseStr = response.result.value{
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let id = jsonResponse["id"].stringValue
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
            UserDefaults().setValue(self.City_Name.text, forKey: "name")
                
                UserDefaults().setValue(iconName, forKey: "icon")
                UserDefaults().setValue(id,forKey: "id")
                UserDefaults().setValue(self.WeatherLabel.text, forKey: "temp")
            }
        }
    }
}

// protocol information from the select city view controller, when user change the city, it will being here and change the relevant data - Zhe Wang 26/Apr/2019
extension Home_ViewController : SelectCityViewControllerDelegate{
    func didSelectNewCity(_ controller: SelectCityViewController, newCity city: LocationInformation, historyCity: [LocationInformation]) {
        self.cityHistory = historyCity
        self.selectedCity = city
        self.City_Name.text = self.selectedCity?.cityName
        
    }
}

// protocol information from the mapview controller, when user select something from actionlist, it will do the action on here to update datas - Dalton 23/Apr/2019
extension Home_ViewController : MapViewControllerDelegate{
    func didSelectANewLocation(_ controller: MapViewController, selectedLocation: CLLocation) {
        // do nothing, it does not relate to this class - Dalton 02/May/2019
    }
    
    func didSelectANewcity(_ controller: MapViewController, selectedCity: LocationInformation) {
        // do nothing, it does not relate to this class - Dalton 02/May/2019
    }
    
    
}


