//
//  PlanCityViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 22/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

protocol PlanCityViewControllerDelegate{
    
}



class PlanCityViewController: UIViewController {
    
    var cities : [CityListInformation]?
    var delegate : PlanCityViewControllerDelegate?
    @IBOutlet weak var cityTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cityTableView.delegate = self
        cityTableView.dataSource = self
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    @IBAction func returnButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "displayCityDestinations"{
            guard let planDetailViewController = segue.destination as? PlanDetailViewController else{fatalError("Unable to reach displayCityDestinations")}
            
            if let cell = sender as? UITableViewCell{
                if let indexPath = cityTableView.indexPath(for: cell),
                    let cities = self.cities{
                    planDetailViewController.city = cities[indexPath.row]
                    planDetailViewController.delegate = self
                }
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

extension PlanCityViewController : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "plan_city_view_cell") as? PlanCityTableViewCell else {fatalError("The dequeued cell is not an instance of PlanCityTableViewCell.")}
        
        if let city = self.cities?[indexPath.row]{
            cell.CityNameLabel.text = city.cityName
            cell.dayLabel.text = "City \(indexPath.row + 1)"
            
            
            cell.City_BackgroundImage.layer.cornerRadius = 8
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.cities?.remove(at: indexPath.row)
        tableView.reloadData()
    }


}

extension PlanCityViewController : PlanDetailViewControllerDelegate{
    
}