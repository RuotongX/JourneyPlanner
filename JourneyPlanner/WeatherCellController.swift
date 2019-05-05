///Applications/JourneyPlanner/JourneyPlanner/ResturantCellController.swift
//  WeatherCellController.swift
//  JourneyPlanner
//
//  Created by RuotongX on 2019/5/1.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class WeatherCellController: UITableViewCell {
    @IBOutlet weak var WeatherIcon: UIImageView!
    @IBOutlet weak var WeatherLabel: UILabel!
    @IBOutlet weak var TempLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    
    func setWeatherf(weatherf:weatherf){
        WeatherIcon.image = weatherf.weatherImage
        WeatherLabel.text = weatherf.weatherLabel
        TempLabel.text = weatherf.tempLabel+"℃"
        DateLabel.text = weatherf.dateLabel
    }

}
