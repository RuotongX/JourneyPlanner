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
import NVActivityIndicatorView
import CoreLocation

class WeatherForcastController: UIViewController {
    
    @IBOutlet weak var WeatherImage: UIImageView!
    @IBOutlet weak var TempLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    weak var CurrentLocationInformation : LocationInformation?
    
    var selectCity : LocationInformation?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.LocationLabel.text = UserDefaults().string(forKey: "name")
//        self.WeatherImage.image = UIImage(named: UserDefaults().string(forKey:"icon")!)
        self.TempLabel.text = UserDefaults().string(forKey:"temp")!
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "MM-dd"
        self.DateLabel.text = timeFormatter.string(from: date as Date) as String
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
    }

    @IBAction func Return(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   

}
