//
//  SelectCityViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 21/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

protocol SelectCityViewControllerDelegate : class{
    func didSelectNewCity(_ controller: SelectCityViewController, newCity city:LocationInformation, historyCity : [LocationInformation])
}

// this class is used to maintain the select city page - Dalton 21 Apr 2019
class SelectCityViewController: UIViewController {

    @IBOutlet weak var SearchContent: UITextField!
    weak var delegate : SelectCityViewControllerDelegate?
    weak var CurrentLocationInformation : LocationInformation?
    
    var selectedCity : LocationInformation?
    var cityHistory : [LocationInformation]?
    
    @IBOutlet weak var CurrentCityLabel: UILabel!
    @IBOutlet weak var CurrentCityButton: UIButton!
    
    @IBOutlet weak var RecentCity1: UILabel!
    @IBOutlet weak var RecentCity1Button: UIButton!
    
    @IBOutlet weak var RecentCity2: UILabel!
    @IBOutlet weak var RecentCity2Button: UIButton!
    
    @IBOutlet weak var RecentCity3: UILabel!
    @IBOutlet weak var RecentCity3Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImages()
        loadHistoryInformation()
        
        if let currentCity = CurrentLocationInformation{
            CurrentCityLabel.text = currentCity.cityName
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
    }
    

    @IBAction func ConfirmButtonPressed(_ sender: Any) {
        // return to the previous view controller - Dalton 21 Apr 2019
        dismiss(animated: true, completion: nil)

        if let selectedCity = selectedCity,
            let history = cityHistory{
            delegate?.didSelectNewCity(self, newCity: selectedCity, historyCity: history)
        }
        
    }
    @IBAction func CancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func CurrentCityButtonPressed(_ sender: UIButton) {
        ButtonPressed(button: sender)
        selectedCity = nil
    }
    
    @IBAction func rencent1ButtonPressed(_ sender: UIButton) {
        ButtonPressed(button: sender)
        selectedCity = cityHistory![cityHistory!.count - 1]
    }
    @IBAction func rencent2ButtonPressed(_ sender: UIButton) {
        ButtonPressed(button: sender)
        selectedCity = cityHistory![cityHistory!.count - 2]
    }
    @IBAction func rencent3ButtonPressed(_ sender: UIButton) {
        ButtonPressed(button: sender)
        selectedCity = cityHistory![cityHistory!.count - 3]
    }
    
    private func ButtonPressed(button : UIButton){
        deselectAllButton()
        button.isSelected = true
    }
    
    
    private func deselectAllButton(){
        CurrentCityButton.isSelected = false
        RecentCity1Button.isSelected = false
        RecentCity2Button.isSelected = false
        RecentCity3Button.isSelected = false
    }
    
    private func setImages(){
        if let Selectedimage = UIImage(named: "Select City-CurrentLocation 1x"){
            CurrentCityButton.setImage(Selectedimage, for: .selected)
            RecentCity1Button.setImage(Selectedimage, for: .selected)
            RecentCity2Button.setImage(Selectedimage, for: .selected)
            RecentCity3Button.setImage(Selectedimage, for: .selected)
        }
    }
    
    private func loadHistoryInformation(){
        
        RecentCity1Button.isHidden = true
        RecentCity2Button.isHidden = true
        RecentCity3Button.isHidden = true

        if let historyCity = cityHistory{
            if historyCity.count == 1{
                RecentCity1.text = historyCity[historyCity.count - 1].cityName
                RecentCity1Button.isHidden = false
                
            } else if historyCity.count == 2{
                
                RecentCity1Button.isHidden = false
                RecentCity2Button.isHidden = false
                RecentCity1.text = historyCity[historyCity.count - 1].cityName
                RecentCity2.text = historyCity[historyCity.count - 2].cityName

            } else if historyCity.count >= 3{
                RecentCity1Button.isHidden = false
                RecentCity2Button.isHidden = false
                RecentCity3Button.isHidden = false
                
                RecentCity1.text = historyCity[historyCity.count - 1].cityName
                RecentCity2.text = historyCity[historyCity.count - 2].cityName
                RecentCity3.text = historyCity[historyCity.count - 3].cityName
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


