//
//  DataBaseTestViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 28/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class DataBaseTestViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let testHistory = SelectCityInformation_Database()
        testHistory.cityName = "Test city 1"
        testHistory.cityZipCode = "Test Zip Code"
        testHistory.cityLocation_Latitude = 25.364444444
        testHistory.cityLocation_Longitude = 218.33333333
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(testHistory)
            print(Realm.Configuration.defaultConfiguration.fileURL)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ReturnButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
