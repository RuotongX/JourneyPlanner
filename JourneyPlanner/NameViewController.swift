//
//  NameViewController.swift
//  JourneyPlanner
//
//  Created by 周启畅 on 24/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {

    
    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var NameTextField: UITextField!
    
    
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
