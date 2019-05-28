//
//  DataBaseTestViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 28/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

class DataBaseTestViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let array = NSArray(objects: "1","2","3")
        let filePath: String = NSHomeDirectory() + "/Documents/webs.plist"
        array.write(toFile: filePath, atomically: true)
        print(filePath)
        
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
