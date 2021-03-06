//
//  ResturantRecommandedController.swift
//  JourneyPlanner
//
//  Created by RuotongX on 2019/5/4.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SwiftyJSON
import CoreLocation
// This class is used to showing more nearby resturants.
class ResturantRecommandedController: UIViewController {
    
    
    // Get the coordinate values from the other class and connect the story board table into this controler. Also create an array to store restaurant object.
    @IBOutlet weak var Table: UITableView!
    let lat = UserDefaults().string(forKey: "lat")
    let lon = UserDefaults().string(forKey: "lon")
    
    var resturants: [Resturant] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getResturants()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCuisineMap"{
            if let navigationController = segue.destination as? UINavigationController{
                if let mapViewController = navigationController.viewControllers.first as?
                    MapViewController{
                    // passing a number which indicate the canteens information, then pass the coordinate to the mapview class
                    
                    if let button = sender as? UIButton{
                        let fingerLocation = button.convert(CGPoint.zero, to: Table)
                        
                        if let indexPath = Table.indexPathForRow(at: fingerLocation){
                            
                            mapViewController.mapsource = .EXPLORE_CANTEEN
                            mapViewController.delegate = self
                            mapViewController.explorePage_canteenLocation = CLLocation(latitude:resturants[indexPath.row].Rlat, longitude: resturants[indexPath.row].Rlon)
                            mapViewController.explorePage_canteenName = resturants[indexPath.row].RName
 
                        }
                        
                    }
                }
            }
        }
    }
   
 
    @IBAction func Return(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Same as I mentioned in weather forcast Controller, this class is to get the api data which is support by Zomato, and take the data value into each restaurant object.
    // The range for showing more restaurant is 2000 meters.
    func getResturants(){
        //The other api key : 1143149f226cce509acd087c44290754
        let header = "b4a1b65c2bd7e6ca955092af1da11545"
        let cuisine = UserDefaults().integer(forKey: "cuisine")
        //https://developers.zomato.com/api/v2.1/geocode?apikey=\(header)&lat=\(lat!)&lon=\(lon!)
        Alamofire.request("https://developers.zomato.com/api/v2.1/search?apikey=\(header)&count=19&lat=\(lat!)&lon=\(lon!)&radius=2000&cuisines=\(cuisine)&sort=rating&order=desc").responseJSON{
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
                    self.resturants.append(resturant)
                }
                //Async method to refresh the table information, reason same as weather forecast Controller. And the double for loop inside is used to get the rank for the restaurants given by Zomato API, the value to called the rank is how many people have voted this restaurant, more people vote, higer rank the resaurant get. The for loop for k one is used to give each restaurant rank value.
                DispatchQueue.main.async {
//                    for i in 0...self.resturants.count-1{
//                        for j in 1...self.resturants.count-2{
//                            if self.resturants[i].votes<self.resturants[j].votes{
//                                let temp = self.resturants[i]
//                                self.resturants[i] = self.resturants[j]
//                                self.resturants[j] = temp
//                            }
//                        }
//                    }
//                    for k in 0...self.resturants.count-1{
//                        self.resturants[k].Rank = k+1
//                    }
                    self.Table.reloadData()
                }
            }
        }

    }
}
// Extension class for control the table
extension  ResturantRecommandedController: UITableViewDelegate,UITableViewDataSource{
    //set table row's height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    // get how many rows does table have
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resturants.count
    }
    //Display the restaurant object information into Weather Cell Controller,
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resturant = resturants[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "resturantcell", for: indexPath) as! ResturantCellController
        cell.setResturant(resturant: resturant)
        return cell
    }
    
    
}
extension ResturantRecommandedController : MapViewControllerDelegate{
    func didSelectANewcity(_ controller: MapViewController, selectedCity: LocationInformation) {
        // do not implement, it does not relate to this class
    }
    
    func didSelectANewLocation(_ controller: MapViewController, selectedLocation: CLLocation, nameOfLocation: String) {
        // do not implement, it does not relate to this class
    }
    
    
}
