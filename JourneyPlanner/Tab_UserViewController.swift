//
//  Tab_UserViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 27/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class Tab_UserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewHistoryPlan"{
            if let planViewController = segue.destination as? PlanViewController{
                
                planViewController.delegate = self
                planViewController.PlanType = .HISTORY
                // add data
            }
        }
    }
    
    @IBAction func historyPlanPressed(_ sender: Any) {
        
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

extension Tab_UserViewController: PlanViewControllerDelegate{
    
}
