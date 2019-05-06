//
//  WeatherCellController.swift
//  JourneyPlanner
//
//  Created by RuotongX on 2019/5/1.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
// this class is used to define the view table cell information
class WeatherCellController: UITableViewCell {
    @IBOutlet weak var WeatherIcon: UIImageView!
    @IBOutlet weak var WeatherLabel: UILabel!
    @IBOutlet weak var TempLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    // this is the method to set the value for each element in this cell
    func setWeatherf(weatherf:weatherf){
        WeatherIcon.image = weatherf.weatherImage
        WeatherLabel.text = weatherf.weatherLabel
        TempLabel.text = weatherf.tempLabel+"℃"
        DateLabel.text = weatherf.dateLabel
    }

}
