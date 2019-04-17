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

class FirstViewController: ViewController {
    
    @IBOutlet weak var City_Name: UILabel!
    
    override func viewDidLoad() {
        // used to load the view, after loading, it can customize items - Dalton Chen
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationPermission()
    }
    
    //location location information (Dalton 16/Apr/2019)
    let locationManager = CLLocationManager()
    //Define a function which obtain the current location information (therefore Dalton 16/Apr/2019)
    
    func locationPermission(){
        var status = CLLocationManager.authorizationStatus()
        
        //check the status of permission, if not determined,request the permission
        
        if status == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        
        status = CLLocationManager.authorizationStatus()
        
        if status == .denied || status == .restricted{
            present(displayLocationPermissionError(), animated: true) {
                self.City_Name.text = "Unknown"
            }
        }
        
        if status == .authorizedWhenInUse{
            permissionGained()
        }
        
    }
    
    func permissionGained(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
	
    
    
    func displayLocationPermissionError() -> UIAlertController{
        let alert = UIAlertController(title: "Location Service is disabled", message: "Please enable location service on the setting page", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        
        return alert
    }
    

    // 1
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        if(currentLocation.horizontalAccuracy > 0){
            locationManager.stopUpdatingLocation()
            
            let geoCoder: CLGeocoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation) { (placemark, error) in
                if(error != nil){
                    print(error!)
                } else {
                    let firstResponseLocation = placemark!.first
                    self.City_Name.text = (firstResponseLocation?.subLocality)!
                }
            }
        }
    }
    
    // 2
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }


}

