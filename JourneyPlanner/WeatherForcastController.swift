//
//  WeatherForcastController.swift
//  JourneyPlanner
//
//  Created by RuotongX on 2019/5/1.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON


class WeatherForcastController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var WeatherImage: UIImageView!
    @IBOutlet weak var TempLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    
    var weathers: [weatherf] = [];
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.LocationLabel.text = UserDefaults().string(forKey: "name")
        self.WeatherImage.image = UIImage(named: UserDefaults().string(forKey:"icon")!)
        self.TempLabel.text = UserDefaults().string(forKey:"temp")!
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "MM-dd"
        self.DateLabel.text = timeFormatter.string(from: date as Date) as String
        getWeathers()
        
    }
    

    @IBAction func Return(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getWeathers()  {
        let id = UserDefaults().string(forKey: "id")
        let apiKey = "d1580a5eaffdf2ae907ca97ceaff0235"
        Alamofire.request("http://api.openweathermap.org/data/2.5/forecast?id=\(id!)&APPID=\(apiKey)").responseJSON{
            response in
            if let responseStr = response.result.value{
                let jsonResponse = JSON(responseStr)
                for i in 0...4 {
                    let j = 7+8*i
                    let jsonDay = jsonResponse["list"].array![j]
                    let jsonWeather = jsonDay["weather"].array![0]
                    let weather = jsonWeather["main"].stringValue
                    let jsonTemp = jsonDay["main"]
                    var iconName = jsonWeather["icon"].stringValue
                    switch iconName{
                    case "01d":
                        iconName = "Home-Weather-Sunny"
                        
                        break;
                    case "01n":
                        iconName = "Home-Weather-Sunny"
                       
                        break;
                    case "02d":
                        iconName = "Home-Weather-Partlycloudy"
                       
                        break;
                    case "02n":
                        iconName = "Home-Weather-Partlycloudy"
                       
                        break;
                    case "03d":
                        iconName = "Home-Weather-Cloudy"
                       
                        break;
                    case "03n":
                        iconName = "Home-Weather-Cloudy"
                        
                        break;
                    case "04d":
                        iconName = "Home-Weather-Mostlycloudy"
                        
                        break;
                    case "04n":
                        iconName = "Home-Weather-Mostlycloudy"
                        
                        break;
                    case "09d":
                        iconName = "Home-Weather-Sunnyrain"
                       
                        break;
                    case "09n":
                        iconName = "Home-Weather-Sunnyrain"
                       
                        break;
                    case "10d":
                        iconName = "Home-Weather-rain"
                        
                        break;
                    case "10n":
                        iconName = "Home-Weather-rain"
                       
                        break;
                    case "11d":
                        iconName = "Home-Weather-Thunder"
                       
                        break;
                    case "11n":
                        iconName = "Home-Weather-Thunder"
                       
                        break;
                    case "13d":
                        iconName = "Home-Weather-Mostlycloudy"
                        
                        break;
                    case "13n":
                        iconName = "Home-Weather-Mostlycloudy"
                       
                        break;
                    case "50d":
                        iconName = "Home-Weather-Fog"
                        
                        break;
                    case "50n":
                        iconName = "Home-Weather-Fog"
                       
                        break;
                    default:
                        break;
                    }
                    let temp = "\(Int(round(jsonTemp["temp"].doubleValue))-273)"
                    let date = jsonDay["dt_txt"].stringValue
                  
                    let forcast = weatherf()
                    forcast.weatherImage = UIImage(named: iconName)!
                    forcast.weatherLabel = weather
                    forcast.tempLabel = temp
                    let date1 = String(date.prefix(10))
                    let date2 = String(date1.suffix(5))
                    forcast.dateLabel = date2
                    self.weathers.append(forcast)
                    
                }
                
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
        }
    }
}

extension  WeatherForcastController: UITableViewDelegate,UITableViewDataSource{

    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weathers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherf = weathers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "weathercell", for: indexPath) as! WeatherCellController
        cell.setWeatherf(weatherf: weatherf)
        return cell
    }
    
    
}
