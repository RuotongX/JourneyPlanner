//
//  ZomatoWeb.swift
//  JourneyPlanner
//
//  Created by RuotongX on 2019/5/7.
//  Copyright © 2019 RuotongX. All rights reserved.
// This class is used to display the web page by using Safari.

import UIKit
import Foundation
import SafariServices

class ViewController2: UIViewController, SFSafariViewControllerDelegate {}

class ZomatoWeb: ViewController2 {

    // This function is to recognize user click, once user touch the screen it will load Safari to display the website. The URL is from restaurant cell.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let ZomatoUrl = UserDefaults().string(forKey: "ZomatoUrl")
        guard let url = URL(string: ZomatoUrl!)
            else {return}
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)
    }
    
// Go back to previous page.
    @IBAction func `return`(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
