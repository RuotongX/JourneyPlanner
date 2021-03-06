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
    @IBOutlet weak var TravelTimeSelect: UITableView!
    @IBOutlet weak var SearchBar: UITextField!
    @IBOutlet weak var SearchButton: UIButton!
    
    
    var selectedPlanDate : Int!
    // this section is designed to provide the necessay materials for the plan creator
    @IBOutlet weak var PlanDesignerAdd: UIButton!
    @IBOutlet weak var PlanDesignerMinus: UIButton!
    @IBOutlet weak var PlanDesignerDay: UILabel!
    
    @IBOutlet weak var WeatherLabel: UILabel!
    @IBOutlet weak var WeatherIcon: UIImageView!
    
    @IBOutlet weak var TravelTImeSelect: UITableView!
    
    
    let WeatherApiKey = "d1580a5eaffdf2ae907ca97ceaff0235"
    let locationManager = CLLocationManager()
    var CurrentCity : LocationInformation?
    var selectedCity : LocationInformation?
    @IBOutlet weak var City_Name: UILabel!
    
    //Below is set upt the current city information items Dalton 24/Apr/2019
    required init?(coder aDecoder: NSCoder) {
        self.CurrentCity = LocationInformation()
        super.init(coder: aDecoder)
        
    }
    
    // when user open the software, this viewdidload will be automatically called
    override func viewDidLoad() {
        // used to load the view, after loading, it can customize items - Dalton Chen
        super.viewDidLoad()
        SearchBar.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        selectedPlanDate = 0;
        PlanDesignerDay.text = "1 - 3 Days"
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
//                selectCityController.cityHistories = self.cityHistory
                // set up the delegate is used to passing the value between target and this class Dalton 27/Apr/2019
                selectCityController.delegate = self
            }
        }
        
        // if user clicked the plan designer button, it will jump to that page and passing the value for it, it will need two value, first is the minimum time and second is maximum time
        if segue.identifier == "PlanDesignerSegue"{
            if let planDesignerViewController = segue.destination as? RouteListViewController{
                planDesignerViewController.delegate = self
                
                if self.selectedPlanDate == 0{
                    planDesignerViewController.StopTimeA = 1
                    planDesignerViewController.StopTimeB = 3
                } else {
                    planDesignerViewController.StopTimeA = 4
                    planDesignerViewController.StopTimeB = 9
                }
            }
        }
        
        if segue.identifier == "transferCityInfo" || segue.identifier == "searchButtonPressed"{
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
                
                if segue.identifier == "searchButtonPressed"{
                    mapviewController?.mapsource = .HOMEPAGE_SEARCH
                    mapviewController?.homePage_SearchBarContent = self.SearchBar.text
                }
                
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
                    self.CheckWeather(_location: selectedCity.location)
                }
            }
        }
        
        // when user is providing the location information, keep process it
        if status == .authorizedWhenInUse{
            // request single location (Dalton 27/Apr/2019)
            locationManager.requestLocation()
        }
        
    }
    
    // if the add button is pressed, this method will be called, when there is no more date less, it will using taptic engine to notify user, same as there is reached maximum duration.
    @IBAction func addButtonPressed(_ sender: Any) {
        if selectedPlanDate == 0{
            //using taptic engine to generate vibrate
            let impactFeedBackGenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedBackGenerator.prepare()
            impactFeedBackGenerator.impactOccurred()
            
            
            PlanDesignerDay.text = "4 - 9 Days"
            selectedPlanDate = 1
        } else {
            let error = UINotificationFeedbackGenerator()
            error.notificationOccurred(.error)
        }
    }
    
    // same as previous one, but this time it will become minus
    @IBAction func minusButtonPressed(_ sender: Any) {
        if selectedPlanDate == 1{
            //using taptic engine to generate vibrate
            let impactFeedBackGenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedBackGenerator.prepare()
            impactFeedBackGenerator.impactOccurred()
            
            PlanDesignerDay.text = "1 - 3 Days"
            selectedPlanDate = 0
        } else {
            let error = UINotificationFeedbackGenerator()
            error.notificationOccurred(.error)
        }
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
    
    // Alamofire library is use for weather calling api, to get the the api data out from JSON package is using by swiftyJSON library this is useed the coordinate values to get the information from openWeather, and for the weather image changing part I used a switch case to depend which icon I should use.
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
                //These following code is used the UserDefaults as an deletegate to store the variables, so that I can use these value in the other view Controller.
            UserDefaults().setValue(self.City_Name.text, forKey: "name")
                
                UserDefaults().setValue(iconName, forKey: "icon")
                UserDefaults().setValue(id,forKey: "id")
                UserDefaults().setValue(self.WeatherLabel.text, forKey: "temp")
                UserDefaults().setValue(lat, forKey: "lat")
                UserDefaults().setValue(lon, forKey: "lon")
            }
        }
    }
}
// method is implemented to pass the value
extension Home_ViewController : RouteListViewControllerDelegate{
    // no method is list out.
}

// protocol information from the select city view controller, when user change the city, it will being here and change the relevant data - Zhe Wang 26/Apr/2019
extension Home_ViewController : SelectCityViewControllerDelegate{
    // if user has selected new city
    func didSelectNewCity(_ controller: SelectCityViewController, newCity city: LocationInformation) {
        self.selectedCity = city
        self.City_Name.text = self.selectedCity?.cityName
    }
    
    // if user has deselect new city
    func didSelectCurrentCity(_ controller: SelectCityViewController) {
        self.selectedCity = nil
        self.City_Name.text = CurrentCity?.cityName
        
        if let currentcity = self.CurrentCity{
            CheckWeather(_location: currentcity.location)

        }
        
    }
    
}
// settings about the textfield on homepage is defined here
extension Home_ViewController : UITextFieldDelegate{
    
    //when user press return, the keyboard will be dismiss
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchBar.resignFirstResponder()
        return true
    }
    
    //when user prees anywhere else, the keboard will dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// protocol information from the mapview controller, when user select something from actionlist, it will do the action on here to update datas - Dalton 23/Apr/2019
extension Home_ViewController : MapViewControllerDelegate{
    func didSelectANewLocation(_ controller: MapViewController, selectedLocation: CLLocation, nameOfLocation: String) {
        // do nothing, it does not relate to this class - Dalton 02/May/2019

    }
    
    func didSelectANewcity(_ controller: MapViewController, selectedCity: LocationInformation) {
        // do nothing, it does not relate to this class - Dalton 02/May/2019
    }
    
    
}


