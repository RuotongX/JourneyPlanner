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
    var lat : String?
    var lon : String?
    @IBOutlet weak var Table: UITableView!
    
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var gasButton: UIButton!
    @IBOutlet weak var hotelButton: UIButton!
    
    
    //This tableViewData is store 10 different cuisine information, sectionData inside is used to store the preview restaurants.
    var tableViewData = [cellData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        lat = UserDefaults().string(forKey: "lat")
        lon = UserDefaults().string(forKey: "lon")
        tableViewData = [cellData(opened: false, cuisine: "Chinese",sectionData:[],cuisineN:25),
                         cellData(opened: false, cuisine: "Japanese",sectionData:[],cuisineN:60),
                         cellData(opened: false, cuisine: "Korean",sectionData:[],cuisineN:67),
                         cellData(opened: false, cuisine: "American",sectionData:[],cuisineN:1),
                         cellData(opened: false, cuisine: "Fast Food",sectionData:[],cuisineN:40),
                         cellData(opened: false, cuisine: "French",sectionData:[],cuisineN:45),
                         cellData(opened: false, cuisine: "Mexican",sectionData:[],cuisineN:73),
                         cellData(opened: false, cuisine: "Healthy Food",sectionData:[],cuisineN:143),
                         cellData(opened: false, cuisine: "Indian",sectionData:[],cuisineN:148),
                         cellData(opened: false, cuisine: "Malaysian",sectionData:[],cuisineN:69)
        ]
    }
    //This function is used to refresh page information, if the current location is not same as the previous location, the restaurant will be loaded again by using the new location.
    override func viewDidAppear(_ animated: Bool) {
        obtainTheCurrentLocationInformation()
        if(self.lat != UserDefaults().string(forKey: "lat")&&self.lon != UserDefaults().string(forKey: "lon")){
            for i in 0...tableViewData.count-1{
                tableViewData[i].sectionData.removeAll()
                getResturants(index: i)
            }
        }
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
        if segue.identifier == "showCanteenAtMap"{
            if let navigationController = segue.destination as? UINavigationController{
                if let mapViewController = navigationController.viewControllers.first as?
                    MapViewController{
                    // passing a number which indicate the canteens information, then pass the coordinate to the mapview class
                    //test data, remove when actualy data arrive
                    if let button = sender as? UIButton{
                        //Get the cell index by checking user click position
                        let fingerLocation = button.convert(CGPoint.zero, to: Table)
                        if let indexPath = Table.indexPathForRow(at: fingerLocation){
                            let restaurant = self.tableViewData[indexPath.section].sectionData[indexPath.row-1]
                            let testLocation = CLLocation(latitude: restaurant.Rlat, longitude: restaurant.Rlon)
                            let testLocationName = restaurant.RName
                            
                            mapViewController.mapsource = .EXPLORE_CANTEEN
                            mapViewController.delegate = self
                            mapViewController.explorePage_canteenLocation = testLocation
                            mapViewController.explorePage_canteenName = testLocationName
                        }
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
    
    
    @IBAction func Shopping(_ sender: Any) {
        self.keyword = "shopping"
    }
    
    @IBAction func Gas(_ sender: Any) {
        self.keyword = "gas"
    }
    @IBAction func Bank(_ sender: Any) {
        self.keyword = "bank"
    }
    
    @IBAction func Hotel(_ sender: Any) {
        self.keyword = "hotel"
    }
    
    
    // disable all the button if user could not provide the location information - Qichang Zhou 04/May/2019
    private func disableButtons(){
        // this class is used to disable all buttons
        
        gasButton.isEnabled = false
        shoppingButton.isEnabled = false
        hotelButton.isEnabled = false
        bankButton.isEnabled = false
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    // This function is used to get the previewed 3 restaurant which is locate in the range of 500 meters. API is zomato
    func getResturants(index:Int){
        let header = "b4a1b65c2bd7e6ca955092af1da11545"
        let cuisine = tableViewData[index].cuisineN
        
        if let lat = UserDefaults().string(forKey: "lat"),
            let lon = UserDefaults().string(forKey: "lon"){
            Alamofire.request("https://developers.zomato.com/api/v2.1/search?apikey=\(header)&count=3&lat=\(lat)&lon=\(lon)&radius=500&cuisines=\(cuisine)&sort=rating&order=desc").responseJSON{
                response in
                if let responseStr = response.result.value{
                    let jsonResponse = JSON(responseStr)
                    if jsonResponse["restaurants"].array!.count != 0{
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
                    } else{
                        
                    }
                    // The reason that I add 1 restaurant object here is because in table view display, we need to have a cell position for showing more, the empty restaurant is used to create that empty position
                    let resturant1 = Resturant()
                    self.tableViewData[index].sectionData.append(resturant1)
                    DispatchQueue.main.async {
                        self.Table.reloadData()
                    }
                }
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

// This extension is used to control the table view which inside of this view.
extension Explore_ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //The cuisine cell height is 50.
        if tableViewData[indexPath.section].sectionData.count == 1{
            if(indexPath.row == 1){
                return 50
            }
        }
        //The showmore cell height is 70.
        if(indexPath.row == 4)
        {
            return 70
        }
        //The other cell like restaurant cell height is 120.
        return 120
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return tableViewData.count
    }
    // This is used to get how many rows in one section. Section means the cuisine.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true{
            return tableViewData[section].sectionData.count + 1
        } else{
            return 1
        }
    }
    // This function is used to give every cell information by recognize the section index,
    //and call cell by calling their identifier. One section maximum have 4 cell and normally is 5, which are title, 3 restaurant, and show more, if there is no restaurant in one cuisine, the section will have 2 rows which are title and no restaurant yet cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataIndex = indexPath.row - 1
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cuisine") as! CuisineCell
            cell.CuisineName.text = tableViewData[indexPath.section].cuisine
            // This is giving each cuisine different picture.
            switch(tableViewData[indexPath.section].cuisineN){
            case 25:
                cell.CuisinePicture.image = UIImage(named: "Explore-rest-chinese")
                break;
            case 60:
                cell.CuisinePicture.image = UIImage(named: "Explore-rest-Japanese")
                break;
            case 67:
                cell.CuisinePicture.image = UIImage(named: "Explore-rest-korean")
                break;
            case 1:
                cell.CuisinePicture.image = UIImage(named: "Explore-rest-america")
                break;
            case 40:
                cell.CuisinePicture.image = UIImage(named: "Explore-rest-fastfood")
                break;
            case 45:
                cell.CuisinePicture.image = UIImage(named: "Explore-rest-french")
                break;
            case 73:
                cell.CuisinePicture.image = UIImage(named: "Explore-rest-mexican")
                break;
            case 143:
                cell.CuisinePicture.image = UIImage(named: "Explore-rest-healthy")
                break;
            case 148:
                cell.CuisinePicture.image = UIImage(named: "Explore-rest-indian")
                break;
            case 69:
                cell.CuisinePicture.image = UIImage(named: "Explore-rest-malasia")
                break;
            default:
                cell.CuisinePicture.image = UIImage(named: "Explore-rest-default")
                break;
            }
            
            return cell
        }
            // When the count is 4 means this is the empty position that I created the empty restaurant, here I replaced it with show more.
        else if(indexPath.row == 4){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowMore") as! ShowMoreCell
            UserDefaults().set(tableViewData[indexPath.section].cuisineN, forKey: "cuisine")
            return cell
        }
            // This situation is to avoid there is no restaurant in one cuisine
        else{
            if tableViewData[indexPath.section].sectionData.count == 1{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Nothing") else {return UITableViewCell()}
                return cell
            }
            let resturant = tableViewData[indexPath.section].sectionData[dataIndex]
            let cell = tableView.dequeueReusableCell(withIdentifier: "resturantcell", for: indexPath) as! ResturantCellController
            cell.setResturant(resturant: resturant)
            return cell
        }
    }
    // This function is used to control the cuisine open and closed.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if tableViewData[indexPath.section].opened == true{
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else{
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        } else if(indexPath.row == 4){
            
        } else{
            
        }
        
    }
}
