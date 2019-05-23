//
//  PlanViewController.swift
//  JourneyPlanner
//
//  Created by Wanfang Zhou on 23/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

//This class is design to control the plan view controller - Wanfang Zhou 23/04/2019
class PlanViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var plan : [PlanInformations]?
    
    // when this view is loaded, this will be displayed at the first time - Wanfang Zhou 23/04/2019
    override func viewDidLoad() {
        super.viewDidLoad()
        plan = []
        LoadTestData()
        
        tableView.dataSource = self
        tableView.delegate = self

//        tableView.register(PlanTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // when the return button is pressed, go back to the previous page  - Wanfang Zhou 23/04/2019
    @IBAction func returnButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
            attractions.append(AttractionInformation(Name: "Awesome Thai food", Location: CLLocationCoordinate2D(latitude: -38.1387009, longitude: 176.2528075)))
            
            citylists.append(CityListInformation(name: "Cape Reinga", time: 1, location: CLLocationCoordinate2D(latitude: -34.428788, longitude: 172.681003), image: image, attractions: attractions))
            
            citylists.append(CityListInformation(name: "Auckland", time: 1, location: CLLocationCoordinate2D(latitude: -36.848461, longitude: 174.763336), image: image, attractions: attractions))
            
            
            plan?.append(PlanInformations(name: "Test Plan", citylist: citylists, memo: "memo"))
        }
        
    }
    
    
    // this method is used to create the bridge beteen this class and the plan detail view controller - Wanfang Zhou 23/04/2019
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        if segue.identifier == "viewPlanCity"{
            if let planCityViewController = segue.destination as? PlanCityViewController{
                planCityViewController.delegate = self
                
                if let cell = sender as? UITableViewCell{
                    if let indexPath = tableView.indexPath(for: cell),
                        let plan = self.plan{
                        planCityViewController.cities = plan[indexPath.row].City
                    }
                }
            }
        }
        
        
        // if user would likely to create a new trip, it will bring user to an emptry page - Wanfang Zhou 23/04/2019
        if segue.identifier == "newPlanSegue"{
            if let planDetailViewController = segue.destination as? PlanDetailViewController{
                
                //using taptic engine to make vibration
                let impactFeedBackGenerator = UIImpactFeedbackGenerator(style: .medium)
                impactFeedBackGenerator.prepare()
                impactFeedBackGenerator.impactOccurred()
                planDetailViewController.delegate = self
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
extension PlanViewController : PlanDetailViewControllerDelegate{
    
}

extension PlanViewController : PlanCityViewControllerDelegate {
    
}
