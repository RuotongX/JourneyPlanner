//
//  PlanDetailViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 24/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

protocol PlanDetailViewControllerDelegate: class {

}

class PlanDetailViewController: UIViewController {
    
    var plan: TripPlan?
    var delegate:PlanDetailViewControllerDelegate?
    @IBOutlet weak var planNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let plan = plan {
            planNameLabel.text = plan.PlanName
        }
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
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
