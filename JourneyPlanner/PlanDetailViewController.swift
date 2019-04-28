//
//  PlanDetailViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 24/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol PlanDetailViewControllerDelegate: class {

}

class PlanDetailViewController: UIViewController {
    
    var plan: TripPlan?
    var delegate : PlanDetailViewControllerDelegate?
    
    @IBOutlet weak var PlanDetailTableView: UITableView!
    @IBOutlet weak var planNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let plan = plan {
            planNameLabel.text = plan.PlanName
        }
        
        PlanDetailTableView.dataSource = self
        PlanDetailTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // if plan was not existing yet
        askingforPlanName()
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
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
                    address.append("\(StreetNumber)")
                }else{}
                
                // add street
                if let Street = place.thoroughfare{
                    address.append(", \(Street)")
                }else{}
                
                // add city
                if let City = place.locality{
                    address.append(", \(City)")
                }else{}
                
                label.text = address
            }
        }
    }
    
}


extension PlanDetailViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if let plan = plan{
            return plan.trips.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.plan?.trips.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    
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
