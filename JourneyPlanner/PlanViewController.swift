//
//  PlanViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 23/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

class PlanViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var plan : [TripPlan]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plan = []
        LoadTestData()
        
        tableView.dataSource = self
        tableView.delegate = self

//        tableView.register(PlanTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func returnButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
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
        
        
        // Create a new plan
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlanViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.plan?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as? PlanTableViewCell else{ fatalError("The dequeued cell is not an instance of PlanTableViewCell.") }

        if let item = self.plan?[indexPath.row]{
            cell.cityNameLabel.text = item.firstCity.cityName
            cell.distanceLabel.text = "\(String(describing: item.distances)) Km"
            cell.planNameLabel.text = "\(String(describing: item.PlanName))"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect button (unhighlighted) - Dalton 27/Apr/2019
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.plan?.remove(at: indexPath.row)
        tableView.reloadData()
    }

}

extension PlanViewController : PlanDetailViewControllerDelegate{
    
}
