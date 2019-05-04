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

class ResturantRecommandedController: UIViewController {
    
    @IBOutlet weak var Table: UITableView!
    let lat = UserDefaults().string(forKey: "lat")
    let lon = UserDefaults().string(forKey: "lon")
    
    var resturants: [Resturant] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getResturants()
    }
    
    @IBAction func Return(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getResturants(){
        let header = "1143149f226cce509acd087c44290754"
        
        Alamofire.request("https://developers.zomato.com/api/v2.1/geocode?apikey=\(header)&lat=\(lat!)&lon=\(lon!)").responseJSON{
            response in
            if let responseStr = response.result.value{
                let jsonResponse = JSON(responseStr)
                for i in 0...jsonResponse["nearby_restaurants"].array!.count-1{
                    let jsonRest = jsonResponse["nearby_restaurants"].array![i]
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
                    self.resturants.append(resturant)
                }
                DispatchQueue.main.async {
                    self.Table.reloadData()
                }
            }
        }

    }
}

extension  ResturantRecommandedController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("here")
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resturants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resturant = resturants[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "resturantcell", for: indexPath) as! ResturantCellController
        cell.setResturant(resturant: resturant)
        return cell
    }
    
    
}
