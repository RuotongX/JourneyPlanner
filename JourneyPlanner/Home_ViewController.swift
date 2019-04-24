//
//  FirstViewController.swift
//  JourneyPlanner
//
//  Created by RuotongX on 2019/3/20.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {}

class Home_ViewController: ViewController{
    
    var CurrentCity:CityInformation?
    @IBOutlet weak var City_Name: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        self.CurrentCity = CityInformation()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        // used to load the view, after loading, it can customize items - Dalton Chen
        super.viewDidLoad()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationPermission()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CurrentLocationProvider"{
            if let selectCityController = segue.destination as? SelectCityViewController{
                selectCityController.city = self.CurrentCity
                selectCityController.delegate = self
            }
        }
        
        if segue.identifier == "tranferCityInfo"{
            if let mapviewController = segue.destination as? MapViewController{
                mapviewController.selectedCity = CurrentCity
                mapviewController.delegate = self
            }
        }
    }
    
    //location location information (Dalton 16/Apr/2019)
    let locationManager = CLLocationManager()
    
    //Define a function which obtain the current location information (therefore Dalton 16/Apr/2019)
    func locationPermission(){
        let status = CLLocationManager.authorizationStatus()
        
        //check the status of permission, if not determined,request the permission
        if status == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        
        if status == .denied || status == .restricted{
            self.present(displayLocationPermissionError(), animated: true) {
                self.City_Name.text = "Unknown"
            }
        }
        
        if status == .authorizedWhenInUse{
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
        }
        
    }

	
    func displayLocationPermissionError() -> UIAlertController{
        let alert = UIAlertController(title: "Location Service is disabled", message: "Please enable location service on the setting page", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        
        return alert
    }
    

    // obtain the city names and display it 21 Apr 2019 Dalton
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        if(currentLocation.horizontalAccuracy > 0){
            locationManager.stopUpdatingLocation()
            self.CurrentCity?.lontitude = currentLocation.coordinate.longitude
            self.CurrentCity?.latitude = currentLocation.coordinate.latitude
            
            let geoCoder: CLGeocoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation) { (placemark, error) in
                if(error != nil){
                    print(error!)
                } else {
                    let firstResponseLocation = placemark!.first
                    self.City_Name.text = (firstResponseLocation?.subLocality)!
                    self.CurrentCity?.cityName = (firstResponseLocation?.subLocality)!
                    self.CurrentCity?.zipCode = (firstResponseLocation?.postalCode)!
                }
            }
        }
    }
    
    // cannot obtain the current location, display error message 21 Apr 2019 Dalton
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    // if user changed the permission authorization, it will value it again for services
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationPermission()
    }


}

extension Home_ViewController : SelectCityViewControllerDelegate{
    func didSelectNewCity(_ controller: SelectCityViewController, newCity city: CityInformation) {
        print("Hello")
    }
}

extension Home_ViewController : MapViewControllerDelegate{
    
}


