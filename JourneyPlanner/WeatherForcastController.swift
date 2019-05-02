//
//  WeatherForcastController.swift
//  JourneyPlanner
//
//  Created by RuotongX on 2019/5/1.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit



class WeatherForcastController: UIViewController, Home_ViewControllerDelegate {
    
    @IBOutlet weak var WeatherImage: UIImageView!
    @IBOutlet weak var TempLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    weak var CurrentLocationInformation : LocationInformation?
    
    var selectCity : LocationInformation?
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        let Home_ViewController = Home_ViewController(nibName:"Home_ViewController",bundle:nil)
//        Home_ViewController.delegate = self
//        presentedViewController(Home_ViewController,animated: true, completion: nil)
        
    }
    
    func passOnInformation(_ controller: Home_ViewControllerDelegate, newCity city: LocationInformation) {
        self.CurrentLocationInformation = city
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
    }

    @IBAction func Return(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   

}
