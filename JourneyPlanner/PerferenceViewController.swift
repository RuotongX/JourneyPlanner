//
//  PerferenceViewController.swift
//  JourneyPlanner
//
//  Created by 周启畅 on 6/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class PerferenceViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var MapTypeTextField: UITextField!
    @IBOutlet weak var NameLabel: UILabel!
    
    var selectedMapType = UserDefaults.standard.integer(forKey: "MapType")
    
    let mapType_arr = ["Standard","Setellite","Hybrid"]
    var active_textField : UITextField!
    
    let my_pickerView = UIPickerView()
    
    var current_arr : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapTypeTextField.delegate = self
        
        my_pickerView.delegate = self
        my_pickerView.dataSource = self

        MapTypeTextField.inputView = my_pickerView
        
        creat_toolbar()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let manager = DBManager.sharedInstance()
        let perfrence = manager?.archivePerferenceModel();
        if (perfrence != nil && ((perfrence?.name) != nil))  {
            NameLabel.text = perfrence?.name
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        active_textField = textField
        
        switch textField {
        case MapTypeTextField:
            current_arr = mapType_arr
            
        default:
            print("Default")
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
        
        self.selectedMapType = row
        
        active_textField.text = current_arr[row]
    }
    
    func creat_toolbar() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        MapTypeTextField.inputAccessoryView = toolbar
        
}
    
    @objc func doneClick() {
        active_textField.resignFirstResponder()
        UserDefaults.standard.set(selectedMapType, forKey: "MapType")
    }
    
    @objc func cancelClick() {
        active_textField.text = ""
        active_textField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func `return`(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
