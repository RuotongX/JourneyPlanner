//
//  PlanViewController.swift
//  JourneyPlanner
//
//  Created by Wanfang Zhou on 23/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

enum planType{
    case NORMAL
    case HISTORY
}

protocol PlanViewControllerDelegate {
    
}


//This class is design to control the plan view controller - Wanfang Zhou 23/04/2019
class PlanViewController: UIViewController {

    var delegate : PlanViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    var plan : [PlanInformations]?
    var PlanType : planType = .NORMAL
    @IBOutlet weak var addButton: UIButton!
    // when this view is loaded, this will be displayed at the first time - Wanfang Zhou 23/04/2019
    override func viewDidLoad() {
        super.viewDidLoad()
        plan = []
        LoadTestData()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if PlanType == .HISTORY{
            self.addButton.isHidden = true
        }
        

//        tableView.register(PlanTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // when the return button is pressed, go back to the previous page  - Wanfang Zhou 23/04/2019
    @IBAction func returnButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Plan Name", message: "Please enter plan name to continue", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Plan Name"
        }
        let confirm = UIAlertAction(title: "OK", style: .default) { (action) in
            
            if let textfields = alert.textFields{
                if let text = textfields.first?.text{
                    if text.isEmpty == false{
                        let cityList : [CityListInformation] = []
                        self.plan?.append(PlanInformations(name: text, citylist: cityList, memo: ""))
                        self.tableView.reloadData()

                    }
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert,animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    // this method is used to load the test date please remove before submit  - Wanfang Zhou 23/04/2019
    // PLEASE REMOVE BEFORE SUBMIT !!!!!!!
    func LoadTestData(){
        
        if let image = UIImage(named: "Trip-Piha_90_2x"){
            
            var citylists : [CityListInformation] = []

            var attractions : [AttractionInformation] = []
            
            attractions.append(AttractionInformation(Name: "Cape Reinga Lighthouse", Location: CLLocationCoordinate2D(latitude: -34.426639, longitude: 172.677639)))
            attractions[0].attractionImage = UIImage(named: "Tripe-Cape_Reinga_1x")
            attractions[0].attractionImageName = "Tripe-Cape_Reinga_1x"
            
            
            attractions.append(AttractionInformation(Name: "Awesome Thai food", Location: CLLocationCoordinate2D(latitude: -38.1387009, longitude: 176.2528075)))
            
            citylists.append(CityListInformation(name: "Cape Reinga", time: 1, location: CLLocationCoordinate2D(latitude: -34.428788, longitude: 172.681003), image: image, attractions: attractions))
            
            citylists.append(CityListInformation(name: "Auckland", time: 1, location: CLLocationCoordinate2D(latitude: -36.848461, longitude: 174.763336), image: image, attractions: attractions))
            
            
            plan?.append(PlanInformations(name: "Test Plan", citylist: citylists, memo: "memo"))
        }
        
    }
    
    private func saveData(){
//        if let plans = self.plan{
//            
//            var plan_Full_DB : [PlanInformation_Database] = []
//            
//            for plan in plans{
//                
//                let cityList : [CityInformation_Database] = []
//                
//                for city in plan.City{
//                    var attactionList : [AttractionInformation_Database] = []
//
//                    // save attraction information
//                    if let attractions = city.Attractions{
//                        for attraction in attractions{
//                            
//                            let attraction_DB = AttractionInformation_Database()
//                            
//                            attraction_DB.AttractionName = attraction.attractionName
//                            attraction_DB.AttractionLocation_Lon = attraction.attractionLocation.longitude
//                            attraction_DB.AttractionLocation_Lan = attraction.attractionLocation.latitude
//                            
//                            if let attraction_IMG = attraction.attractionImageName{
//                                attraction_DB.AttractionImg = attraction_IMG
//                            } else {
//                                attraction_DB.AttractionImg = "attraction_default"
//                            }
//                            attactionList.append(attraction_DB)
//                        }
//                    }
//                    
//                    let cityDB = CityInformation_Database()
//                    cityDB.CityName = city.cityName
//                    cityDB.StopTime = city.cityStopTime
//                    cityDB.CityLocation_Lat = city.cityLocation.latitude
//                    cityDB.CityLocation_Lon = city.cityLocation.longitude
//                    cityDB.CityImgName = "City-\(city.cityName.lowercased())"
//                    
//                    for at in attactionList{
//                        cityDB.attractionList.append(at)
//                    }
//                }
//                
//                let planDB = PlanInformation_Database()
//                planDB.PlanMemo = plan.memo
//                planDB.PlanName = plan.planName
//                
//                for city in cityList{
//                    planDB.cities.append(city)
//                }
//                plan_Full_DB.append(planDB)
//            }
//        }
        
        
        
        
    }
    
    
    // this method is used to create the bridge beteen this class and the plan detail view controller - Wanfang Zhou 23/04/2019
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        if segue.identifier == "viewPlanCity"{
            if let planCityViewController = segue.destination as? PlanCityViewController{
                planCityViewController.delegate = self
                
                if let cell = sender as? UITableViewCell{
                    if let indexPath = tableView.indexPath(for: cell),
                        let plan = self.plan{
                        planCityViewController.planIndexNumber = indexPath.row
                        planCityViewController.cities = plan[indexPath.row].City
                        
                        if PlanType == .HISTORY{
                            planCityViewController.PlanType = .HISTORY
                        }
                    }
                }
            }
        }
        
        
        // if user would likely to create a new trip, it will bring user to an emptry page - Wanfang Zhou 23/04/2019

        
        if segue.identifier == "ShowMemo"{
            if let memoViewController = segue.destination as? MemoViewController{
                
                // obtain current row
                if let button = sender as? UIButton{
                    let fingerLocation = button.convert(CGPoint.zero, to: tableView)
                    
                    if let indexPath = tableView.indexPathForRow(at: fingerLocation){
                        
                        if let plans = self.plan{
                            let selectedPlan = plans[indexPath.row]
                            
                            memoViewController.memo = selectedPlan.memo
                            memoViewController.indexNumber = indexPath.row
                            memoViewController.delegate = self

                        }
                    }
                    
                }
            }
        }
    }

}

// this section is used to provide define the uitable view source and customize the content  - Wanfang Zhou 23/04/2019
extension PlanViewController : UITableViewDataSource, UITableViewDelegate{
    
    // return how many rows that tableview will have, the default value is 0  - Wanfang Zhou 23/04/2019
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.plan?.count ?? 0
    }
    
    // this function is used to customize the tableview cell, it fills the name and all necessary information  - Wanfang Zhou 23/04/2019
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as? PlanTableViewCell else{ fatalError("The dequeued cell is not an instance of PlanTableViewCell.") }
        
        if let planCellInformation = self.plan?[indexPath.row]{
            
            var stopTime = 0
            var cities = ""
            
            
            //calculate the spent time and cities for a trip
            for city in planCellInformation.City{
                
                // count stop time
                stopTime = city.cityStopTime + stopTime
                cities = cities + city.cityName + " "
            }
            

            cell.planNameLabel.text = planCellInformation.planName
            cell.dayDurationLabel.text = "\(stopTime) day"
            cell.CitiesLabel.text = cities
            
            if stopTime > 1 {
                cell.dayDurationLabel.text = cell.dayDurationLabel.text! + "s"
            }
            
        }
        
        return cell
    }
    
    // when user preseed the the cell, it will not stuck in selected color - Wanfang Zhou 27/04/2019
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // this method is allow user to swipe to delete function  - Wanfang Zhou 23/04/2019
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.plan?.remove(at: indexPath.row)
        tableView.reloadData()
    }

}

// this extentsion creates the bridge between the this class and plan detail view class  - Wanfang Zhou 23/04/2019
extension PlanViewController : PlanCityViewControllerDelegate {
    func updateDestinations(_ controller: PlanCityViewController, cities: [CityListInformation], indexNum: Int) {
        
        print("iNDEX number : \(indexNum)")
        if let plan = self.plan?[indexNum]{
            plan.City = cities
            print("reach")
            self.tableView.reloadData()
        }
    }
}

extension PlanViewController : MemoViewControllerDelegate {
    func updateMemoInformation(_ controller: MemoViewController, memo: String, indexNumber: Int) {
        
        if let plans = self.plan{
            plans[indexNumber].memo = memo
        }
    }
    
    
}
