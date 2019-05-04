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
    var keyword : String?
    
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var barButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var gasButton: UIButton!
    @IBOutlet weak var pharmacyButton: UIButton!
    @IBOutlet weak var hotelButton: UIButton!
    @IBOutlet weak var dairyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        obtainTheCurrentLocationInformation()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exploreShowSuggestions" {
        
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

    @IBAction func Bar(_ sender: Any) {
         self.keyword = "bar"
    }
    
    @IBAction func Shopping(_ sender: Any) {
         self.keyword = "shopping"
    }
    
    @IBAction func Gas(_ sender: Any) {
        self.keyword = "gas"
    }
    @IBAction func Bank(_ sender: Any) {
        self.keyword = "bank"
    }
    @IBAction func Restaurant(_ sender: Any) {
         self.keyword = "restaurant"
    }
    @IBAction func Pharmacy(_ sender: Any) {
         self.keyword = "pharmacy"
    }
    @IBAction func Hotel(_ sender: Any) {
         self.keyword = "hotel"
    }
    @IBAction func Dairy(_ sender: Any) {
         self.keyword = "convenience shop"
    }
    
    
    private func dropAnnotationsToMap(typeKeyWord : String){
        
    }
    
    private func disableButtons(){
        // this class is used to disable all buttons
        restaurantButton.isEnabled = false
        barButton.isEnabled = false
        gasButton.isEnabled = false
        dairyButton.isEnabled = false
        shoppingButton.isEnabled = false
        hotelButton.isEnabled = false
        pharmacyButton.isEnabled = false
        bankButton.isEnabled = false
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
