//
//  ChooseRangeViewController.swift
//  JourneyPlanner
//
//  Created by 周启畅 on 30/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

protocol ChooseRangeViewControllerDelagate : class  {
    
}

class ChooseRangeViewController: UIViewController {

    @IBOutlet weak var RangeLabel: UILabel!
    var delegate : ChooseRangeViewControllerDelagate?
    var range : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let range = range {
            RangeLabel.text = range
        }
        // Do any additional setup after loading the view.
    }
    

    
    
    
    
    @IBAction func Cancel(_ sender: UIButton) {
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
