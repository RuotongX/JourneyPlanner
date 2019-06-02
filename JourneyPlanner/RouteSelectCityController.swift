//
//  SelectCirtyController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 24/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

protocol RouteSelectCityControllerDelgate {
    
}

class RouteSelectCityController: UIViewController {
    
    
    @IBAction func ReturnButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    var delgate : RouteSelectCityControllerDelgate?
    var routeName : String?
    var SelectedCityList : [String]?
    var cityInformation : [CityListInformation] = []
    @IBOutlet weak var routeNameLabel: UILabel!
    
    @IBOutlet weak var SelectCityTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let routeName = routeName{
            routeNameLabel.text = routeName
        }
        
        
        loadCityInformation()

        SelectCityTableview.dataSource = self
        SelectCityTableview.delegate = self
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    @IBAction func swapButtonPressed(_ sender: Any) {
        self.SelectCityTableview.isEditing = !self.SelectCityTableview.isEditing
    }
    
    private func loadCityInformation(){
        
        // load from bundle (left hand side)
        let plistPath = Bundle.main.path(forResource: "CityInformation", ofType: "plist")!
        let cityList = NSArray(contentsOfFile: plistPath)!
        
        cityInformation = []
        
        for cityDict in cityList{
            
            let cityInfo = cityDict as! NSDictionary
            
            let cityName = cityInfo["cityName"] as! String
            
            if let selectedCity = self.SelectedCityList{
                for city in selectedCity{
                    if cityName == city{
                        
                        let cityStopTime = cityInfo["cityStopTime"] as! Int
                        let cityLocation_Lon = cityInfo["cityLocation_lon"] as! Double
                        let cityLocation_lat = cityInfo["cityLocation_lat"] as! Double
                        let cityImageName = cityInfo["cityImage_Name"] as! String
                        
                        if let cityImage = UIImage(named: cityImageName){
                            
                            let city = CityListInformation(name: cityName, time: cityStopTime, location: CLLocationCoordinate2D(latitude: cityLocation_lat, longitude: cityLocation_Lon), image: cityImage)
                            cityInformation.append(city)
                        } else {
                            
                            if let defaultImage = UIImage(named: "City-default"){
                                let city = CityListInformation(name: cityName, time: cityStopTime, location: CLLocationCoordinate2D(latitude: cityLocation_lat, longitude: cityLocation_lat), image: defaultImage)
                                cityInformation.append(city)
                            }
                        }
                    }
                }
            }
            
            
        }
        
    }
    @IBAction func CreateButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Plan Name", message: "What is your plan name", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Plan Name"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if (alert.textFields?.first?.text!.isEmpty)!{
                let erroralert = UIAlertController(title: "Error", message: "Please enter plan name!", preferredStyle: .alert)
                let errorAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                erroralert.addAction(errorAction)
                self.present(erroralert,animated: true)
            }
            
            let newPlan = PlanInformations(name: (alert.textFields?.first?.text!)!, citylist: self.cityInformation, memo: "")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let planViewController = storyBoard.instantiateViewController(withIdentifier: "planviewcontroller") as? PlanViewController
            
            planViewController?.planCreatorData = newPlan
            
            self.present(planViewController!, animated: true,completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert,animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AttractionData"{
            if let selectAttraction = segue.destination as? RouteAttractionController{
                selectAttraction.delegate = self
                
                if let cell = sender as? UITableViewCell{
                    if let indexPath = SelectCityTableview.indexPath(for: cell){
                        selectAttraction.cityName = self.cityInformation[indexPath.row].cityName
                        selectAttraction.cityIndexNumber = indexPath.row
                        
                        
                        if let attractions = self.cityInformation[indexPath.row].Attractions{
                            selectAttraction.SelectedData = attractions
                        }
                    }
                }
            }
        }
        
    }
}
extension RouteSelectCityController : RouteAttractionControllerDelgate{
    func didSelectAttractionFromList(_ controller: RouteAttractionController, SelectedAttraction: [AttractionInformation], indexNumber: Int) {
        cityInformation[indexNumber].Attractions = SelectedAttraction
        self.SelectCityTableview.reloadData()
    }
    
}

extension RouteSelectCityController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        self.cityInformation.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)

    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let data = self.cityInformation[sourceIndexPath.row]
        self.cityInformation.remove(at: sourceIndexPath.row)
        self.cityInformation.insert(data, at: destinationIndexPath.row)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCityCell", for: indexPath) as? RouteSelectCityCell else {
            fatalError("The dequeued cell is not an instance of SelectCityTableviewCellTableViewCell.")
        }
        
        cell.CityName.text = cityInformation[indexPath.row].cityName
        
        cell.CityImage.image = cityInformation[indexPath.row].cityImage
        
        cell.TimeLabel.text = String(cityInformation[indexPath.row].cityStopTime)
        
        if let attraction = cityInformation[indexPath.row].Attractions{
            cell.AttractionNumber.text = "\(attraction.count)"
        } else {
            cell.AttractionNumber.text = "0"
        }
        
        cell.CityImage.layer.cornerRadius = 8
        cell.Background.layer.cornerRadius = 8
//        cell.DarkCoverForImage.layer.cornerRadius = 8
        
        //Define the empty function taht used to set tha action for the increase button - ZHE WANG
        cell.IncreaseButton = {
            
            let impactFeedBackGenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedBackGenerator.prepare()
            impactFeedBackGenerator.impactOccurred()
            
            self.cityInformation[indexPath.row].cityStopTime = self.cityInformation[indexPath.row].cityStopTime + 1
            cell.TimeLabel.text = String(self.cityInformation[indexPath.row].cityStopTime)
            
        }
        
        cell.DecreaseButton = {
            
            if self.cityInformation[indexPath.row].cityStopTime > 1{
                let impactFeedBackGenerator = UIImpactFeedbackGenerator(style: .light)
                impactFeedBackGenerator.prepare()
                impactFeedBackGenerator.impactOccurred()
                
                self.cityInformation[indexPath.row].cityStopTime = self.cityInformation[indexPath.row].cityStopTime - 1
                cell.TimeLabel.text = String(self.cityInformation[indexPath.row].cityStopTime)
            } else{
                let error = UINotificationFeedbackGenerator()
                error.notificationOccurred(.error)
            }
        }
        
        return cell
    }
}

