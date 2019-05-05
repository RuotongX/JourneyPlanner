//
//  AboutViewController.swift
//  JourneyPlanner
//
//  Created by Wanfang Zhou on 1/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

// this method is used to hold the about page and related information - Wanfang Zhou  1/05/2019
class AboutViewController: UIViewController {

    // this method is called when this interface is loaded - Wanfang Zhou  1/05/2019
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // when user click the return button, return to the previous page - Wanfang Zhou  1/05/2019
    @IBAction func ReturnButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
