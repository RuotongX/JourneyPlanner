//
//  SelectCityViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 21/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

protocol SelectCityViewControllerDelegate : class{
    func didSelectNewCity(_ controller: SelectCityViewController, newCity city:CityInformation)
}

// this class is used to maintain the select city page - Dalton 21 Apr 2019
class SelectCityViewController: UIViewController {

    weak var delegate : SelectCityViewControllerDelegate?
    weak var city : CityInformation?
    @IBOutlet weak var CurrentCityLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Load")
        if let currentCity = city{
            print(currentCity.cityName)
            CurrentCityLabel.text = currentCity.cityName
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func ConfirmButtonPressed(_ sender: Any) {
        // return to the previous view controller - Dalton 21 Apr 2019
        dismiss(animated: true, completion: nil)
    }
    @IBAction func CancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
