//
//  MemoViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 24/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

// this class is used to display or allow user to make changes to the memo page


// this protocol is used to update the exisiting memo information
protocol MemoViewControllerDelegate {
    func updateMemoInformation(_ controller: MemoViewController, memo: String,indexNumber: Int)
}

class MemoViewController: UIViewController {

    // this class is difinin the information inside this view controller
    var memo: String?
    var indexNumber: Int?
    var delegate: MemoViewControllerDelegate?
    @IBOutlet weak var memoText: UITextView!
    
    // this method is called when user enter this view controller, it will load any exising memo to the textfield
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo = self.memo{
            memoText.text = memo
        }

        // Do any additional setup after loading the view.
    }
    
    // this method is called when user pressed done button, it will pass the memo information back to the previous page
    @IBAction func DoneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            
            if let memo = self.memoText.text,
                let indexNumber = self.indexNumber{
                
                self.delegate?.updateMemoInformation(self, memo: memo, indexNumber: indexNumber)
            }
            
        }
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
