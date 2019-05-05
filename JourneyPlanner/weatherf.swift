//
//  File.swift
//  weather
//
//  Created by RuotongX on 2019/4/2.
//  Copyright © 2019 RuotongX. All rights reserved.
//
// This class is the model for weather forecast
import Foundation
import UIKit

class weatherf{
    var weatherImage: UIImage
    var dateLabel: String
    var weatherLabel: String
    var tempLabel: String
    // Constructor for each element
    init(image: UIImage, date:String,weather:String,temp:String){
        self.weatherImage = image
        self.dateLabel = date
        self.weatherLabel = weather
        self.tempLabel = temp
    }
    //This is the default constructor for this class.
        init(){
            self.weatherImage = UIImage(named:"Home-Weather-Cloudy")!
            self.dateLabel = "date"
            self.weatherLabel = "Sunny"
            self.tempLabel = "20"
    
        }
}
