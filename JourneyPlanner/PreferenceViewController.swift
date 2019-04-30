//
//  PreferenceViewController.swift
//  JourneyPlanner
//
//  Created by 周启畅 on 30/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController{

    @IBOutlet weak var SelectRange: UILabel!
    @IBOutlet weak var Username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PassingNameSegue" {
            if let nameViewController = segue.destination as? NameViewController {
                nameViewController.delegate = self
                nameViewController.name = Username.text
            }
        }
        
        if segue.identifier == "PassRangeSegue" {
            if let chooseRangeController = segue.destination as? ChooseRangeViewController {
                chooseRangeController.delegate = self
                chooseRangeController.range = SelectRange.text
            }
        }
    }
    
    
    @IBAction func BurronPessed(_ sender: UIButton) {
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

extension PreferenceViewController: NameViewControllerDelagate {
    func returnUsername(_ controller: NameViewController, name: String) {
        print(name)
        Username.text = name
    }
    
    
}

extension PreferenceViewController : ChooseRangeViewControllerDelagate {
    
}
