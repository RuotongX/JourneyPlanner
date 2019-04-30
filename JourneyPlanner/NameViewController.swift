//
//  NameViewController.swift
//  JourneyPlanner
//
//  Created by 周启畅 on 30/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

protocol NameViewControllerDelagate : class  {
    func returnUsername(_ controller: NameViewController, name: String)
}

class NameViewController: UIViewController {
    var delegate : NameViewControllerDelagate?
    var name : String?
    
    @IBOutlet weak var SaveNameButton: UIButton!
    @IBOutlet weak var NameTextFiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let name = name {
            NameTextFiled.text = name
        }
        
    }
    
    @IBAction func SaveButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

        if let name = name {
            delegate?.returnUsername(self, name: name)
            print(name)
        }
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
