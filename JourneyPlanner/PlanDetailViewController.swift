//
//  PlanDetailViewController.swift
//  JourneyPlanner
//
//  Created by Wanfang Zhou on 24/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// this method is used to control the plan detail  - Wanfang Zhou  25/04/2019
protocol PlanDetailViewControllerDelegate: class {

}

class PlanDetailViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    var plan: TripPlan?
    var delegate : PlanDetailViewControllerDelegate?
    
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var PlanDetailTableView: UITableView!
    @IBOutlet weak var planNameLabel: UILabel!

    // this method is called when the interface is loaded - Wanfang Zhou  25/04/2019
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let plan = plan {
            planNameLabel.text = plan.PlanName
        }
        
        PlanDetailTableView.dataSource = self
        PlanDetailTableView.delegate = self
        
        
        EditButton.setImage(UIImage(named: "PlanDetail-done 1x"), for: .selected)
    }
    
    // this method is called when the page is successfully loaded - Wanfang Zhou  25/04/2019
    override func viewDidAppear(_ animated: Bool) {
        // if plan was not existing yet
        askingforPlanName()
    }

    // when user click the edit button, all the information will goes to the edit button - Wanfang Zhou  25/04/2019
    @IBAction func editButtonPressed(_ sender: Any) {
        self.tableview.isEditing = !self.tableview.isEditing
        self.EditButton.isSelected = !self.EditButton.isSelected
    }
    
    // when there is editing mode, set the everthing to the edit mode - Wanfang Zhou  25/04/2019
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableview.setEditing(tableview.isEditing, animated: true)
    }
    
    // this method is called when passing the value between different classed - Wanfang Zhou  25/04/2019
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ViewTrip"{
            if let tripdetailViewController = segue.destination as? tripDetailViewController{

                tripdetailViewController.delegate = self

                if let cell = sender as? UITableViewCell{
                    if let indexPath = tableview.indexPath(for: cell),
                        let plan = plan{
                        tripdetailViewController.trip = plan.trips[indexPath.row]
                        tripdetailViewController.oldtripNumber = indexPath.row
                    }

                }

            }
        }
        
        if segue.identifier == "addNewTrip"{
            if let tripdetailViewController = segue.destination as? tripDetailViewController{
                
                tripdetailViewController.delegate = self
            }
        }
    
    }
    
    // when user click the return button, return to previous page - Wanfang Zhou  25/04/2019
    @IBAction func returnButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // this method is called when user wants to create a new plan, it will asking user for the plan name - Wanfang Zhou  25/04/2019
    private func askingforPlanName(){
        if let _ = plan{} else{
            let alert = UIAlertController(title: "Enter Plan Name", message: "Please enter Plan name", preferredStyle: .alert)
            alert.addTextField { (textfield) in
                textfield.placeholder = "Plan Name"
                textfield.keyboardType = .default
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            let confirm = UIAlertAction(title: "Confirm", style: .default) { (action) in
                let planName = alert.textFields?.first?.text
                self.planNameLabel.text = planName
            }
            
            alert.addAction(cancel)
            alert.addAction(confirm)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    // obtain the street level infromation using geocoder - Wanfang Zhou  25/04/2019
    private func updateStreet(location : CLLocation, label:UILabel){
        
        let geoCoder = CLGeocoder()
        var address : String = ""

        geoCoder.reverseGeocodeLocation(location) { (plackMark, error) in
            
            if let error = error{
                print(error.localizedDescription)
                fatalError("Cannot convert location to street level information")
            }
            
            if let place = plackMark?.first{
                
                // add street number
                if let StreetNumber = place.subThoroughfare {
                    address.append("\(StreetNumber) ")
                }else{}
                
                // add street
                if let Street = place.thoroughfare{
                    address.append("\(Street) ")
                }else{}
                
                // add city
                if let City = place.locality{
                    address.append("\(City)")
                }else{}
                
                label.text = address
            }
        }
    }
    
}

extension PlanDetailViewController : tripDetailViewControllerDelagate{
    
    // if user is adding new plan, this function will let the other page knows that the content is updated - Wanfang Zhou  25/04/2019
    func didNewPlan(_ controller: tripDetailViewController, trip: SmallTripInformation) {
        print("didnewplan called")
        if let plan = plan{
            trip.arragement = plan.trips.count + 1
            plan.addTrip(trip: trip)
            tableview.reloadData()
            print(plan.trips.count)
        }
    }
    
    // if user is replacing exisitng plan, this function will let the other page knows that the content is updated - Wanfang Zhou  25/04/2019

    func didUpdatePlan(_ controller: tripDetailViewController, trip : SmallTripInformation, oldTrip : SmallTripInformation, position : Int) {
        print("didupdateplan called")
        
        self.plan?.trips.remove(at: position)
        self.plan?.trips.insert(trip, at: position)
        self.plan?.trips[position].arragement = position + 1
        tableview.reloadData()

    }
    
}


// this extension is used to handle the up tableview controller - Wanfang Zhou  25/04/2019
extension PlanDetailViewController : UITableViewDelegate, UITableViewDataSource{
    // return the size of the plan (how many plan)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if let plan = plan{
            return plan.trips.count
        }
        
        return 0
    }
    // allow user to change the sequence of the plan  - Wanfang Zhou  25/04/2019
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if let plan = plan{
            plan.move(item: plan.trips[sourceIndexPath.row], to: destinationIndexPath.row, source: sourceIndexPath.row)
        }
        tableView.reloadData()
    }
    
    // allow user to remove the plan by swiping it  - Wanfang Zhou  25/04/2019
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.plan?.trips.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    // load the information for that tableview cell - Wanfang Zhou  25/04/2019
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? PlanDetailTableViewCell else{fatalError("The dequeued cell is not an instance of PlanDetailTableViewCell.")
        }
        
        if let item = self.plan?.trips[indexPath.row]{
            cell.LocationNameLabel.text = "\(item.name)"
            cell.StayLengthLabel.text = "\(item.staylength) mins"
            cell.SequenceNumber.text = "\(item.arragement)"
            cell.StreetLabel.text = "Loading..."
            
            updateStreet(location: item.location, label: cell.StreetLabel)
            
            if let memo = item.memo{
                cell.MemoLabel.text = memo
            } else {
                cell.MemoLabel.isHidden = true
            }
        }
        
        
        return cell
    }
    
    
}
