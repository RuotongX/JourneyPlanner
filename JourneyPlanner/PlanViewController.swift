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
    var plan : [TripPlan]?
    
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
        let coor1 = CLLocation(latitude: -38.1387009, longitude: 176.2528075)
        let trip1 = SmallTripInformation(name: "Awesome Thai food", location: coor1, staylength: 60, arrangement: 1)
        trip1.memo = "this is memo"
        
        let coor2 = CLLocation(latitude: -38.1347549, longitude: 176.2517591)
        let trip2 = SmallTripInformation(name: "Fat Dog Cafe & Bar", location: coor2, staylength: 70, arrangement: 2)
        
        var testTrip :  [SmallTripInformation] = []
        testTrip.append(trip1)
        testTrip.append(trip2)
        
        let testCityInfo = LocationInformation(cityName: "test", lontitude: 0.00, latitude: 0.00, zipCode: "123")
        
        self.plan?.append(TripPlan(trips: testTrip, firstCity: testCityInfo, distances: 123, PlanName: "my trip to wellington"))
    }
    
    
    // this method is used to create the bridge beteen this class and the plan detail view controller - Wanfang Zhou 23/04/2019
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // View Plan detail
        if segue.identifier == "PlanDetailSegue"{
            if let plandetailViewController = segue.destination as?
                PlanDetailViewController{
                
                if let cell = sender as? UITableViewCell{
                    if let indexPath = tableView.indexPath(for: cell){
                        let planDetail = plan?[indexPath.row]
                        plandetailViewController.plan = planDetail
                    }
                }
                plandetailViewController.delegate = self
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

        if let item = self.plan?[indexPath.row]{
            cell.cityNameLabel.text = item.firstCity.cityName
            cell.distanceLabel.text = "\(String(describing: item.distances)) Km"
            cell.planNameLabel.text = "\(String(describing: item.PlanName))"
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
