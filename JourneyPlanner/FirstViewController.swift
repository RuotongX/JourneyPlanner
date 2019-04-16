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

    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        // used to load the view, after loading, it can customize items - Dalton Chen
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //location location information (Dalton 16/Apr/2019)
    let locationManager = CLLocationManager()
    //Define a function which obtain the current location information (therefore Dalton 16/Apr/2019)
    @IBAction func ButtonPressed(_ sender: UIButton) {
        getLocation()
    }
    
    func getLocation(){
        let status = CLLocationManager.authorizationStatus()
        
        //check the status of permission, if not determined,request the permission
        
        if status == .notDetermined{
            locationManager.requestWhenInUseAuthorization();
        }
        
        if status == .denied || status == .restricted{
            present(displayLocationPermissionError(), animated: true) {
                print("Unknown Location")
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
                    print(error)
                } else {
                    //print("coor: \(location.coordinate.latitude)")
                    let firstResponseLocation = placemark!.first
                    //                print(firstResponseLocation?.subLocality)
                    self.testLabel.text = (firstResponseLocation?.subLocality)!
                    //                print(cityName)
                }
            }
        }
    }
    
    // 2
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }


}

