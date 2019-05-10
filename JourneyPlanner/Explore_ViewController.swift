//
//  Explore_ViewController.swift
//  JourneyPlanner
//
//  Created by Qichang Zhou on 4/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import Foundation
import SwiftyJSON

// this method is used to declear the explore page, explore page currently have few button which is used to suggest the nearst facilities for user - Qichang Zhou 04/May/2019
struct cellData{
    var opened = Bool()
    var cuisine = String()
    var sectionData = [Resturant]()
    var cuisineN = Int()
}
class Explore_ViewController: UIViewController {
    
    var obtainedLocation: CLLocation?
    var keyword : String?
    @IBOutlet weak var Table: UITableView!
    
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var barButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var gasButton: UIButton!
    @IBOutlet weak var pharmacyButton: UIButton!
    @IBOutlet weak var hotelButton: UIButton!
    @IBOutlet weak var dairyButton: UIButton!
    
    
    var tableViewData = [cellData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewData = [cellData(opened: false, cuisine: "Chinese",sectionData:[],cuisineN:25),cellData(opened: false, cuisine: "Japanese",sectionData:[],cuisineN:60)]
    }
    override func viewDidAppear(_ animated: Bool) {
        obtainTheCurrentLocationInformation()
    }
    
    // this method will load when passing data from this class to another class - Qichang Zhou 04/May/2019
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
    
    // this function is used to obtain the current user location information and passing it to the mapview controller - Qichang Zhou 04/May/2019
    // map part work with Qijin Chen 04/May/2109
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
    
    
    // when user unable to provide the location information or have not select the city yet, it will display information to notify the user - Qichang Zhou 04/May/2019
    private func errorMsgCannotObtainCurrentLocation(){
        let alertController : UIAlertController = UIAlertController(title: "Unknown Location", message: "Unable to get your location, please allow this app to obtain your current location or select city from home page", preferredStyle: .alert)
        let alertAction : UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
        disableButtons()
    }

    // thereafter, when user click the button, show the nearby locations- Qichang Zhou 04/May/2019
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
    
    // disable all the button if user could not provide the location information - Qichang Zhou 04/May/2019
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
    
    func getResturants(cuisine:Int,index:Int){
        let header = "1143149f226cce509acd087c44290754"
        let lat = UserDefaults().string(forKey: "lat")
        let lon = UserDefaults().string(forKey: "lon")
        Alamofire.request("https://developers.zomato.com/api/v2.1/search?apikey=\(header)&count=20&lat=\(lat!)&lon=\(lon!)&radius=2000&cuisines=\(cuisine)&sort=rating&order=desc").responseJSON{
            response in
            if let responseStr = response.result.value{
                let jsonResponse = JSON(responseStr)
                for i in 0...jsonResponse["restaurants"].array!.count-1{
                    let jsonRest = jsonResponse["restaurants"].array![i]
                    let jsonR = jsonRest["restaurant"]
                    let jsonRating = jsonR["user_rating"]
                    let jsonLocation = jsonR["location"]
                    let Name = jsonR["name"].stringValue
                    let Url = jsonR["url"].stringValue
                    let Price = jsonR["average_cost_for_two"].doubleValue/2
                    let rate = jsonRating["aggregate_rating"].stringValue
                    let cuisines = jsonR["cuisines"].stringValue
                    let lat = jsonLocation["latitude"].doubleValue
                    let lon = jsonLocation["longitude"].doubleValue
                    let image = jsonR["thumb"].stringValue
                    let resturant = Resturant()
                    let votes = jsonRating["votes"].intValue
                    // The image is an URL, 59-67 lines is to displayed the URL image in the restaurants table.
                    let url = URL(string: image)
                    if let url = url{
                        do {
                            let data = try Data(contentsOf: url)
                            resturant.RImage = UIImage(data: data)!
                        }catch let error as NSError {
                            print(error)
                        }
                    }
                    resturant.RName = Name
                    resturant.RCost = Price
                    resturant.RMark = rate
                    resturant.RType = cuisines
                    resturant.Rlat = lat
                    resturant.Rlon = lon
                    resturant.RUrl = Url
                    resturant.votes = votes
                    self.tableViewData[index].sectionData.append(resturant)
                }
                let resturant1 = Resturant()
                self.tableViewData[index].sectionData.append(resturant1)
            }
        }
        
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

// this section is provide information when exchange with the mapview controller- Qichang Zhou 04/May/2019
extension Explore_ViewController:MapViewControllerDelegate{
    func didSelectANewcity(_ controller: MapViewController, selectedCity: LocationInformation) {
         // do not implement this method, it does not relate to this class Dalton 4/May/2019
    }
    
    func didSelectANewLocation(_ controller: MapViewController, selectedLocation: CLLocation, nameOfLocation: String) {
        // do not implement this method, it does not relate to this class Dalton 4/May/2019
    }
    
    
    
}

extension Explore_ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults().set(tableViewData[indexPath.section].cuisineN, forKey: "cuisine")
    }
    
}
