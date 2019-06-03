//
//  PlanCityViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 22/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

// this class is design to display the city information in the plan detail view page
protocol PlanCityViewControllerDelegate{
    func updateDestinations(_ controller: PlanCityViewController, cities: [CityListInformation],indexNum:Int)
}

class PlanCityViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    var PlanType : planType = .NORMAL
    var cities : [CityListInformation]?
    var delegate : PlanCityViewControllerDelegate?
    var planIndexNumber : Int?
    @IBOutlet weak var cityTableView: UITableView!
    
    // this method will be called when user pressed the button
    override func viewDidLoad() {
        super.viewDidLoad()

        cityTableView.delegate = self
        cityTableView.dataSource = self
        
        if PlanType == .HISTORY{
            self.addButton.isHidden = true
        }
        
        
    }
    
    // this method will tell the complier that the status bar should be white
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    // this method is called when the return button pressed, it will update the destination information in the previous page
    @IBAction func returnButton(_ sender: Any) {
        self.dismiss(animated: true) {
            
            if let cities = self.cities,
                let delegate = self.delegate,
                let indexNum = self.planIndexNumber{
                delegate.updateDestinations(self, cities: cities,indexNum: indexNum)
            }
        }
    }
    
    
    // this method is used to passing value from this view controller to the next controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        // if user want to see the destinations of a city, it will passing the value by this way
        if segue.identifier == "displayCityDestinations"{
            guard let planDetailViewController = segue.destination as? PlanDetailViewController else{fatalError("Unable to reach displayCityDestinations")}
            
            if let cell = sender as? UITableViewCell{
                if let indexPath = cityTableView.indexPath(for: cell),
                    let cities = self.cities{
                    planDetailViewController.city = cities[indexPath.row]
                    planDetailViewController.delegate = self
                    
                    if PlanType == .HISTORY{
                        planDetailViewController.PlanType = .HISTORY
                    }
                }
            }
            
            
        }
        
        // if user want to create new city, it will display the next viewcontroller
        if segue.identifier == "createPlanCity"{
            guard let CreatedestinationsViewController = segue.destination as?SelectDestinationViewController else {fatalError("Create Destination wrong!")}
            CreatedestinationsViewController.delegate = self
        }
    }
    
}

// this extension is including the value that used to define the tableview information
extension PlanCityViewController : UITableViewDelegate, UITableViewDataSource{


    // this method will return how many city are available in this viewcontroller, if there is no city or cannot found any city, it will return 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.count ?? 0
    }
    
    // when user swipe, delete the city
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            cities?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }

    // customize each cell and display in the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "plan_city_view_cell") as? PlanCityTableViewCell else {fatalError("The dequeued cell is not an instance of PlanCityTableViewCell.")}
        
        if let city = self.cities?[indexPath.row]{
            cell.CityNameLabel.text = city.cityName
            cell.dayLabel.text = "City \(indexPath.row + 1)"
            cell.City_BackgroundImage.layer.cornerRadius = 8
            cell.City_BackgroundImage.image = city.cityImage
        }
        
        return cell
    }
}

// this extension is used to connect two different view controller
extension PlanCityViewController : PlanDetailViewControllerDelegate{
    
}

// when user select a new city, it will be added to this class.
extension PlanCityViewController : SelectDestinationViewControllerDelegate{
    func didSelectNewDestination(_ controller: SelectDestinationViewController, selectedCity: CityListInformation) {

        self.cities?.append(selectedCity)
        self.cityTableView.reloadData()

    }
    
    
}
