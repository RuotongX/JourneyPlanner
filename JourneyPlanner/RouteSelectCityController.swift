//
//  SelectCirtyController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 24/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

//Protocol which using to transfer the data for his superior class - ZHE WANG
protocol RouteSelectCityControllerDelgate {
    
}

//UIViewController which used to manage UI interface for select city page
//Contain the load data method, Data receive form sub class method, user selected method - ZHE WANG
class RouteSelectCityController: UIViewController {
    
    //Set the action of returb button
    @IBAction func ReturnButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //Delgate that used to connect the protocol from Select Attraction Controller - ZHE WANG
    var delgate : RouteSelectCityControllerDelgate?
    
    //Necessary materials for the Select Route
    var routeName : String?
    var SelectedCityList : [String]?
    var cityInformation : [CityListInformation] = []
    @IBOutlet weak var routeNameLabel: UILabel!
    
    @IBOutlet weak var SelectCityTableview: UITableView!
    
    // when user open the software, this viewdidload will be automatically called
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let routeName = routeName{
            routeNameLabel.text = routeName
        }
        
        
        loadCityInformation()

        SelectCityTableview.dataSource = self
        SelectCityTableview.delegate = self
    }
    
    //Set the color of loading bar which at the top of screen
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //Set the action for swap button, that user can drag the city card to change the sort
    @IBAction func swapButtonPressed(_ sender: Any) {
        self.SelectCityTableview.isEditing = !self.SelectCityTableview.isEditing
    }
    
    //Load data method, that will connect and receive the data from Properity List - ZHE WANG
    private func loadCityInformation(){
        
        // load from bundle (left hand side)
        let plistPath = Bundle.main.path(forResource: "CityInformation", ofType: "plist")!
        let cityList = NSArray(contentsOfFile: plistPath)!
        
        cityInformation = []
        
        //Choice which data need to load
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
                        
                        //Write the data to our data constructor that can easy transfer to the sub class by protocol - ZHE WANG
                        //Also include the analyzing conditions that determine wheather the data compare to the user selected. - ZHE WANG
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
    
    //Set the action of Create Plan button, it will transfer all the data to the plan maker function - ZHE WANG
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
    
    //Connect to the correspond segue that transfer the data by protocol - ZHE WANG
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Compare the correspond segue
        if segue.identifier == "AttractionData"{
            if let selectAttraction = segue.destination as? RouteAttractionController{
                selectAttraction.delegate = self
                
                //Compare the segue desentation
                if let cell = sender as? UITableViewCell{
                    if let indexPath = SelectCityTableview.indexPath(for: cell){
                        selectAttraction.cityName = self.cityInformation[indexPath.row].cityName
                        selectAttraction.cityIndexNumber = indexPath.row
                        
                        //Access the delgate and set the correspond data
                        if let attractions = self.cityInformation[indexPath.row].Attractions{
                            selectAttraction.SelectedData = attractions
                        }
                    }
                }
            }
        }
        
    }
}

//Set the delete function, which will chage the index value after user deleted a city
extension RouteSelectCityController : RouteAttractionControllerDelgate{
    func didSelectAttractionFromList(_ controller: RouteAttractionController, SelectedAttraction: [AttractionInformation], indexNumber: Int) {
        cityInformation[indexNumber].Attractions = SelectedAttraction
        self.SelectCityTableview.reloadData()
    }
    
}

//inherence UITableview delgate and data source
//Inclues the paramters setting on UI page - ZHE WANG
extension RouteSelectCityController : UITableViewDelegate, UITableViewDataSource{
    
    //Return the cell that user deleted
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //Determine wheather the cell has been deleted
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //Chage the cell number
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        self.cityInformation.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)

    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Remove the data of the cell that user deleted.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let data = self.cityInformation[sourceIndexPath.row]
        self.cityInformation.remove(at: sourceIndexPath.row)
        self.cityInformation.insert(data, at: destinationIndexPath.row)
    }
    
    //Return the number of cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityInformation.count
    }
    
    //Reuseable - set reuseable function for the cell
    //Only need to create one cell, other row will reuse the first cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        //Set the cell to be a reuseable cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCityCell", for: indexPath) as? RouteSelectCityCell else {
            fatalError("The dequeued cell is not an instance of SelectCityTableviewCellTableViewCell.")
        }
        
        //Set the content paramters for the items on select city page.
        cell.CityName.text = cityInformation[indexPath.row].cityName
        
        cell.CityImage.image = cityInformation[indexPath.row].cityImage
        
        cell.TimeLabel.text = String(cityInformation[indexPath.row].cityStopTime)
        
        //Change the paramter of attraciton label, that will show how many attractions that user selected.
        if let attraction = cityInformation[indexPath.row].Attractions{
            cell.AttractionNumber.text = "\(attraction.count)"
        } else {
            cell.AttractionNumber.text = "0"
        }
        
        //Set the laybout paramters for the items on select city page.
        cell.CityImage.layer.cornerRadius = 8
        cell.Background.layer.cornerRadius = 8
        
        //Define the empty function taht used to set tha action for the increase button - ZHE WANG
        cell.IncreaseButton = {
            
            let impactFeedBackGenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedBackGenerator.prepare()
            impactFeedBackGenerator.impactOccurred()
            
            self.cityInformation[indexPath.row].cityStopTime = self.cityInformation[indexPath.row].cityStopTime + 1
            cell.TimeLabel.text = String(self.cityInformation[indexPath.row].cityStopTime)
            
        }
        
        //Define the empty function taht used to set tha action for the decrease button - ZHE WANG
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

