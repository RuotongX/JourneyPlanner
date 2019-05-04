//
//  Explore_ViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 4/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

class Explore_ViewController: UIViewController {
    
    var obtainedLocation: CLLocation?
    var keyword : String? = "Coffee"
    
    @IBOutlet weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        obtainTheCurrentLocationInformation()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController{
            if let mapViewController = navigationController.viewControllers.first as? MapViewController{
                
                if let location = obtainedLocation,
                    let keyword = keyword{
                    mapViewController.mapsource = .EXPLOREPAGE
                    mapViewController.explorePage_UserLocation = location
                    mapViewController.explorePage_Suggestionkeyword = keyword
                }
            }
        }
    }
    
    private func obtainTheCurrentLocationInformation(){
        if let homeViewController = tabBarController?.viewControllers?[0] as? Home_ViewController{
            
            if let currentLocation = homeViewController.CurrentCity{
                
                // if there is unable to get the current location information, it will dispaly relevent information and disable the suggestion labels - Qichang Zhou
                if currentLocation.cityName == "Unknown"{
                    errorMsgCannotObtainCurrentLocation()
                } else {
                    // when user selected city from select city page, it will using the user one rather than default one, if there is no selected city then it will using user's current location - Qichang Zhou
                    if let selectedCity = homeViewController.selectedCity{
                        obtainedLocation = selectedCity.location
                    } else {
                        obtainedLocation = currentLocation.location
                    }
                }
            }
            
        }
    }
    
    private func errorMsgCannotObtainCurrentLocation(){
        let alertController : UIAlertController = UIAlertController(title: "Unknown Location", message: "Unable to get your location, please allow this app to obtain your current location or select city from home page", preferredStyle: .alert)
        let alertAction : UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
        disableButtons()
    }
    @IBAction func TestButtonAction(_ sender: Any) {
        
        
    }
    
    private func dropAnnotationsToMap(typeKeyWord : String){
        
    }
    
    private func disableButtons(){
        // this class is used to disable all buttons
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Explore_ViewController:MapViewControllerDelegate{
    func didSelectANewcity(_ controller: MapViewController, selectedCity: LocationInformation) {
        // do not implement this method, it does not relate to this class Dalton 4/May/2019
    }
    
    func didSelectANewLocation(_ controller: MapViewController, selectedLocation: CLLocation) {
        // do not implement this method, it does not relate to this class Dalton 4/May/2019
    }
    
    
}
