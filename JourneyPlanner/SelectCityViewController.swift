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

    weak var delegate : SelectCityViewControllerDelegate?
    weak var CurrentLocationInformation : LocationInformation?

    
    var selectedCity : LocationInformation?
    var cityHistories : [LocationInformation]?
    
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
        
        setSelectedIcon()

        // Do any additional setup after loading the view.
    }
    
    func setSelectedIcon(){
        deselectAllButton()
        CurrentCityButton.isSelected = true
        
        if let selectedCity = selectedCity,
            let cityHistory = cityHistories{
            
            if selectedCity.cityName == cityHistory[cityHistory.count - 1].cityName{
                CurrentCityButton.isSelected = false
                RecentCity1Button.isSelected = true
            } else if selectedCity.cityName == cityHistory[cityHistory.count - 2].cityName{
                CurrentCityButton.isSelected = false
                RecentCity2Button.isSelected = true
            } else if selectedCity.cityName == cityHistory[cityHistory.count - 3].cityName{
                CurrentCityButton.isSelected = false
                RecentCity3Button.isSelected = true
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "selectNewCity"{
            if let navigationController = segue.destination as? UINavigationController{
                if let mapViewController = navigationController.viewControllers.first as? MapViewController{
                    
                    mapViewController.mapsource = .CHANGECITY
                    mapViewController.delegate = self
                    
                    if let selectedCity = self.selectedCity{
                        mapViewController.changeCity_CurrentCity = selectedCity
                    } else {
                        mapViewController.changeCity_CurrentCity = self.CurrentLocationInformation
                    }
                }
            }
        }
        
    }
    

    @IBAction func ConfirmButtonPressed(_ sender: Any) {
        // return to the previous view controller - Dalton 21 Apr 2019
        dismiss(animated: true, completion: nil)

        if let selectedCity = selectedCity,
            let history = cityHistories{
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
        selectedCity = cityHistories![cityHistories!.count - 1]
    }
    @IBAction func rencent2ButtonPressed(_ sender: UIButton) {
        ButtonPressed(button: sender)
        selectedCity = cityHistories![cityHistories!.count - 2]
    }
    @IBAction func rencent3ButtonPressed(_ sender: UIButton) {
        ButtonPressed(button: sender)
        selectedCity = cityHistories![cityHistories!.count - 3]
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

        if let historyCity = cityHistories{
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


extension SelectCityViewController: MapViewControllerDelegate{
    func didSelectANewLocation(_ controller: MapViewController, selectedLocation: CLLocation, nameOfLocation: String) {
        // do not implement this method, it does not relate to this class Dalton 4/May/2019
    }
    
    func didSelectANewcity(_ controller: MapViewController, selectedCity: LocationInformation) {
        
        if let currentLocation = CurrentLocationInformation{
            
            // when the selected city = to current city, update city to current city and cancel selected city
            if currentLocation.cityName == selectedCity.cityName{
                deselectAllButton()
                self.CurrentCityButton.isSelected = true
                self.selectedCity = nil
            } else {
                
                if let history = cityHistories{
                    for(index, history) in history.enumerated(){
                        if history.cityName == selectedCity.cityName{
                            self.cityHistories?.remove(at: index)
                        }
                    }
                }
                cityHistories?.append(selectedCity)
                
                loadHistoryInformation()
                deselectAllButton()
                RecentCity1Button.isSelected = true
                self.selectedCity = selectedCity
            }
            
        }
        
    }
    
    
    
    
}

