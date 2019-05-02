//
//  PreferenceViewController.swift
//  JourneyPlanner
//
//  Created by 周启畅 on 30/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var recommandRangeTextField: UITextField!
    @IBOutlet weak var mapTypeTextField: UITextField!
    
    
    
//    var rangerInMeter : Intadditional?
    let rangeParameter_arr = ["off","5km","10km","15km","20km","25km"]
    let maptype_arr = ["Standard","Satellite","Hybird"]
    let my_pickerView = UIPickerView()
    var current_arr : [String] = []
    var active_textFiled : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any  setup after loading the view.
        recommandRangeTextField.delegate = self
        mapTypeTextField.delegate = self
        
        my_pickerView.delegate = self
        my_pickerView.dataSource = self
        
        mapTypeTextField.inputView = my_pickerView
        recommandRangeTextField.inputView = my_pickerView
        
        creat_toolbar()
        
//        RangePicker?.delegate = self
        
    }
    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
    
    //Mark : TextField delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        active_textFiled = textField
        
        switch textField {
        case recommandRangeTextField:
            current_arr = rangeParameter_arr
            
        case mapTypeTextField:
            current_arr = maptype_arr
            
        default:
            print("")
        }
        
        my_pickerView.reloadAllComponents()
        
        return true
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return current_arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return current_arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(current_arr[row])
        active_textFiled.text = current_arr[row]
//        UserDefaults.setValue(active_textField.text, forKey: "test")
    }
    
    func creat_toolbar() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancelClick))
        
        toolbar.setItems([doneButton ,spaceButton ,cancelButton], animated: false)
        
        mapTypeTextField.inputAccessoryView = toolbar
        recommandRangeTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneClick() {
        active_textFiled.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        active_textFiled.text = ""
        active_textFiled.resignFirstResponder()
    }
    
    


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PassingNameSegue" {
            if let nameViewController = segue.destination as? NameViewController {
                nameViewController.delegate = self
                nameViewController.name = Username.text
            }
        }
        
    }
    
//    @IBAction func RangeButtonPressed(_ sender: Any) {
//        RangePicker.isHidden = false
//    }
//
//    @IBAction func BurronPessed(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
//    }
    
    
    
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

//extension PreferenceViewController : UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
//
//
//
////    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
////
////    }
//
//
//
//}

    


