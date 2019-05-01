//
//  PreferenceViewController.swift
//  JourneyPlanner
//
//  Created by 周启畅 on 30/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController{

    @IBOutlet weak var RangeLabel: UILabel!
    @IBOutlet weak var Username: UILabel!
    
    
    @IBOutlet weak var RangePicker: UIPickerView!
    
    var rangerInMeter : Int?
    let rangeParameter : [String] = ["off","5","10","15","20","25"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        RangePicker?.delegate = self
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PassingNameSegue" {
            if let nameViewController = segue.destination as? NameViewController {
                nameViewController.delegate = self
                nameViewController.name = Username.text
            }
        }
        
    }
    
    @IBAction func RangeButtonPressed(_ sender: Any) {
        RangePicker.isHidden = false
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

extension PreferenceViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rangeParameter.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if rangeParameter[row] == "off"{
            return "off"
        }
        return "\(rangeParameter[row]) km"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if rangeParameter[row] == "off"{
            RangeLabel.text = "off"
        } else{
            RangeLabel.text = "\(rangeParameter[row]) km"
        }
    }
    
    
}

