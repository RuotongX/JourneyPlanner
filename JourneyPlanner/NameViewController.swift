//
//  NameViewController.swift
//  JourneyPlanner
//
//  Created by 周启畅 on 24/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

// This class is control all the action in name view page.
import UIKit

class NameViewController: UIViewController {

    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var NameTextField: UITextField!
    
// control done button
    override func viewDidLoad() {
        super.viewDidLoad()
        DoneButton.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func doneClick() {
        let manager = DBManager.sharedInstance()
        manager?.savePerferenceName(NameTextField.text)
        NameTextField.text = ""
        NameTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
// return to top-level menue
    @IBAction func `return`(_ sender: Any) {
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
