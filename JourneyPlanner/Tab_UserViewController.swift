//
//  Tab_UserViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 27/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

// this view controller is hold the information for the 4th tab view controller
class Tab_UserViewController: UIViewController {

    // this method is used every time when user pressed into this view controller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // this method is called when passing value around
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewHistoryPlan"{
            if let planViewController = segue.destination as? PlanViewController{
                
                planViewController.delegate = self
                planViewController.PlanType = .HISTORY
                // add data
            }
        }
    }
    
    // when history button pressed, do the following action 
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

// this method is used to create connection between this one and the plan
extension Tab_UserViewController: PlanViewControllerDelegate{
    
}
