//
//  File.swift
//  weather
//
//  Created by RuotongX on 2019/4/2.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import Foundation
import UIKit

class weatherf{
    var weatherImage: UIImage
    var dateLabel: String
    var weatherLabel: String
    var tempLabel: String
    
    init(image: UIImage, date:String,weather:String,temp:String){
        self.weatherImage = image
        self.dateLabel = date
        self.weatherLabel = weather
        self.tempLabel = temp
    }
        init(){
            self.weatherImage = UIImage(named:"Home-Weather-Cloudy")!
            self.dateLabel = "date"
            self.weatherLabel = "Sunny"
            self.tempLabel = "20"
    
        }
}
