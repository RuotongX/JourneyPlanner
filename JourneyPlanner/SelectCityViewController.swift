//
//  SelectCityViewController.swift
//  JourneyPlanner
//
//  Created by Zhe Wang on 21/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

// this protocol is write to tranfer data between this class and home class, when user select a new city, it will bring back to the home view controller and do the relevant jobs - Zhe Wang 24/Apr/2019
protocol SelectCityViewControllerDelegate : class{
    func didSelectNewCity(_ controller: SelectCityViewController, newCity city:LocationInformation)
    func didSelectCurrentCity(_ controller: SelectCityViewController)
}

// this class is used to maintain the select city page - Zhe Wang 21 Apr 2019
class SelectCityViewController: UIViewController {

    // deleagete is necessay when passing the data
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
    
    // this method is used when the page is loaded, this method will be automatically called
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromDatabase()
        setImages()
        loadHistoryInformation()
        
        
        if let currentCity = CurrentLocationInformation{
            CurrentCityLabel.text = currentCity.cityName
        }
        
        setSelectedIcon()
    }
    
    
    // this function is used to set up the icon, when there is a history city information, it will let the button set to selected - Zhe Wang 21/Apr/2019
    private func setSelectedIcon(){
        deselectAllButton()
        CurrentCityButton.isSelected = true
        
        // when there is selected city and
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
    
    // this method is prepared to passing the value from this class to the mapview class, it will provide the city infromation to the mapview controller - Zhe Wang 21/Apr/2019 work with Dalton 21/Apr/2019
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
    

    // when the confirm button is pressed, the user sould go back to the previous page and get a city changed - Zhe Wang 21/Apr/2019
    @IBAction func ConfirmButtonPressed(_ sender: Any) {
        // return to the previous view controller - Zhe Wang 21 Apr 2019
        dismiss(animated: true, completion: nil)

        if let selectedCity = selectedCity{
            delegate?.didSelectNewCity(self, newCity: selectedCity)
        } else if selectedCity == nil{
            delegate?.didSelectCurrentCity(self)
        }
        
        saveToDatabase()
        
    }
    
    // this method is used to load information from the database to the application
    private func loadFromDatabase(){
        
        cityHistories = []
        
        let realm = try! Realm()
        let historyResult = realm.objects(SelectCityInformation_Database.self)
        
        for result in historyResult{
         
            let locationInfo = LocationInformation(cityName: result.cityName, lontitude: result.cityLocation_Longitude, latitude: result.cityLocation_Latitude, zipCode: result.cityZipCode)
            cityHistories?.append(locationInfo)
        }
    }
    
    
    
    private func saveToDatabase(){
        //save data on database
        
        let realm = try! Realm()
        let historyDB = realm.objects(SelectCityInformation_Database.self)
        
        try! realm.write {
            realm.delete(historyDB)
            
            if let histories = self.cityHistories{
                for history in histories{
                    
                    let updateHistoryDB = SelectCityInformation_Database()
                    updateHistoryDB.cityName = history.cityName
                    updateHistoryDB.cityZipCode = history.zipCode
                    updateHistoryDB.cityLocation_Longitude = history.location.coordinate.longitude
                    updateHistoryDB.cityLocation_Latitude = history.location.coordinate.latitude
                    
                    realm.add(updateHistoryDB)
                }
            }
            
        }
    }
    
    
    // when user click the calcel button, return to the previous view controller and do nothin - Zhe Wang 21/Apr/2019
    @IBAction func CancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // when the current city button is pressed, set current location to current city - Zhe Wang 22/Apr/2019
    @IBAction func CurrentCityButtonPressed(_ sender: UIButton) {
        ButtonPressed(button: sender)
        selectedCity = nil
    }
    // when the recent city button 1 is pressed, set current location to latest histroy city - Zhe Wang 22/Apr/2019
    @IBAction func rencent1ButtonPressed(_ sender: UIButton) {
        ButtonPressed(button: sender)
        selectedCity = cityHistories![cityHistories!.count - 1]
    }
    // when the recent city button 2 is pressed, set current location to second latest histroy city - Zhe Wang 22/Apr/2019
    @IBAction func rencent2ButtonPressed(_ sender: UIButton) {
        ButtonPressed(button: sender)
        selectedCity = cityHistories![cityHistories!.count - 2]
    }
    // when the recent city button 3 is pressed, set current location to third latest histroy city - Zhe Wang 22/Apr/2019
    @IBAction func rencent3ButtonPressed(_ sender: UIButton) {
        ButtonPressed(button: sender)
        selectedCity = cityHistories![cityHistories!.count - 3]
    }
    
    // this function defines the action of the button - Zhe Wang 22/Apr/2019
    private func ButtonPressed(button : UIButton){
        deselectAllButton()
        button.isSelected = true
    }
    
    // when this method is called, all the selection to the button will set to false - Zhe Wang 22/Apr/2019
    private func deselectAllButton(){
        CurrentCityButton.isSelected = false
        RecentCity1Button.isSelected = false
        RecentCity2Button.isSelected = false
        RecentCity3Button.isSelected = false
    }
    
    // this function is used to add the selected image to the current button, when the button is selected, it will display the relevant image - Zhe Wang  21/04/2019
    private func setImages(){
        if let Selectedimage = UIImage(named: "Select City-CurrentLocation 1x"){
            CurrentCityButton.setImage(Selectedimage, for: .selected)
            RecentCity1Button.setImage(Selectedimage, for: .selected)
            RecentCity2Button.setImage(Selectedimage, for: .selected)
            RecentCity3Button.setImage(Selectedimage, for: .selected)
        }
    }
    
    // this function is used to load the history information and also load relevant button information - Zhe Wang 22/04/2019
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

}


// this protocol is used between the select city viewcontroller and the mapview interface - Wang Zhe 25/Apr/2019 - Work with Dalton 25/Apr/2019
extension SelectCityViewController: MapViewControllerDelegate{
    func didSelectANewLocation(_ controller: MapViewController, selectedLocation: CLLocation, nameOfLocation: String) {
        // do not implement this method, it does not relate to this class Dalton 4/May/2019
    }
    
    func didSelectANewcity(_ controller: MapViewController, selectedCity: LocationInformation) {
        
        if let currentLocation = CurrentLocationInformation{
            
            // when the selected city = to current city, update city to current city and cancel selected city - Wang zhe
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
                // add this city tot he city histroy list - Wang Zhe
                cityHistories?.append(selectedCity)
                
                loadHistoryInformation()
                deselectAllButton()
                RecentCity1Button.isSelected = true
                self.selectedCity = selectedCity
            }
            
        }
        
    }
    
    
    
    
}

