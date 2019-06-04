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

// this enum define the type of the view page, it can be normal and it also can be history
enum planType{
    case NORMAL
    case HISTORY
}

// this method is defined for user to passing the data around
protocol PlanViewControllerDelegate {
    
}


//This class is design to control the plan view controller - Wanfang Zhou 23/04/2019
class PlanViewController: UIViewController {

    var delegate : PlanViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    var plan : [PlanInformations]?
    var planCreatorData : PlanInformations?
    var PlanType : planType = .NORMAL
    @IBOutlet weak var addButton: UIButton!
    // when this view is loaded, this will be displayed at the first time - Wanfang Zhou 23/04/2019
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
//        LoadTestData()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if PlanType == .HISTORY{
            self.addButton.isHidden = true
        }
        
        
        if let newPlan = planCreatorData{
            plan?.append(newPlan)
            self.tableView.reloadData()
            self.saveData()
        }

//        tableView.register(PlanTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // when the return button is pressed, go back to the previous page  - Wanfang Zhou 23/04/2019
    @IBAction func returnButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        saveData()
    }
    
    // this method is called when the add button is pressed, it will pop up a windows to ask user to enter the plan name, if the plan name is empty it will send another window to user
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
                        self.saveData()

                    }
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert,animated: true)
    }
    
    // this method define the status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    // this method is called when this page is opened, this method will load data from the database and store it to the local file
    private func loadData(){
        
        plan = []
        
        let realm = try! Realm()
        let planDB = realm.objects(PlanInformation_Database.self)
        
        for result in planDB{
            
            let cities = city_Decoder(cities: result.cities)
            let newPL = PlanInformations(name: result.PlanName, citylist: cities, memo: result.PlanMemo)
            
            plan?.append(newPL)
        }
    }
    
    // this method is used to decode the city information from the database, it will convetn the database format of information into the citylist information
    private func city_Decoder(cities: List<CityInformation_Database>) -> [CityListInformation]{
        var cityList : [CityListInformation] = []
        
        for city in cities{
            let attraction = attraction_Decoder(attractions: city.attractionList)
            
            if let CTimg = UIImage(named: city.CityImgName){
                let newCT = CityListInformation(name: city.CityName, time: city.StopTime, location: CLLocationCoordinate2D(latitude: city.CityLocation_Lat, longitude: city.CityLocation_Lon), image: CTimg, attractions: attraction)
                cityList.append(newCT)
            }
        }
        
        return cityList
    }
    
    
    
    // this method is used to convert the attraction information from the database format to attraction formation
    private func attraction_Decoder(attractions : List<AttractionInformation_Database>) -> [AttractionInformation]{
        
        var attractionList : [AttractionInformation] = []
        
        for attract in attractions{
            let newAt = AttractionInformation(Name: attract.AttractionName, Location: CLLocationCoordinate2D(latitude: attract.AttractionLocation_Lan, longitude: attract.AttractionLocation_Lon))
            
            if let attimage = UIImage(named: attract.AttractionImg){
                newAt.attractionImage = attimage
                newAt.attractionImageName = attract.AttractionImg
            }
            attractionList.append(newAt)
        }
        
        return attractionList
    }
    
    
    
    
    // this method is used to save the data to the database, it will remove everything and then add it back in order to prevent duplication.
    private func saveData(){
        
        let realm = try! Realm()
        
        // delete following things
        
        let planDB = realm.objects(PlanInformation_Database.self)
        let cityDB = realm.objects(CityInformation_Database.self)
        let attractionDB = realm.objects(AttractionInformation_Database.self)
        
        if let plan = self.plan{
            let result = enCoder_PlanInformation(plans: plan)
            
            try! realm.write {
                realm.delete(planDB)
                realm.delete(cityDB)
                realm.delete(attractionDB)
                
                for plan in result{
                    realm.add(plan)
                }
            }
        }

    }
    
    
    // this method is used to encode the plan information from normal format to the database format
    private func enCoder_PlanInformation(plans : [PlanInformations]) -> [PlanInformation_Database]{
        var planDB : [PlanInformation_Database] = []
        
        for plan in plans{
            let newPL = PlanInformation_Database()
            newPL.PlanName = plan.planName
            newPL.PlanMemo = plan.memo
            
            let result = enCoder_CityInformation(cities: plan.City)
            
            for city in result{
                newPL.cities.append(city)
            }
            
            planDB.append(newPL)
        }
        
        
        return planDB
    }
    
    // this method is used to encode the city information from normal format to the database format
    private func enCoder_CityInformation(cities: [CityListInformation]) -> [CityInformation_Database]{
        var cityDB : [CityInformation_Database] = []
        
        for city in cities{
            let newCt = CityInformation_Database()
            newCt.CityName = city.cityName
            newCt.StopTime = city.cityStopTime
            newCt.CityLocation_Lat = city.cityLocation.latitude
            newCt.CityLocation_Lon = city.cityLocation.longitude
            newCt.CityImgName = "City-\(city.cityName.lowercased())"
            
            if let attractions = city.Attractions{
                let result = enCoder_AttractionInformation(attractions: attractions)
                
                for att in result{
                    newCt.attractionList.append(att)
                }
            }
            cityDB.append(newCt)
        }
        
        return cityDB
    }
    
    // this method is used to convert the attraction information to the database format one
    private func enCoder_AttractionInformation(attractions : [AttractionInformation]) -> [AttractionInformation_Database]{
        
        var attractionsDB : [AttractionInformation_Database] = []
        
        for attractionsmall in attractions{
            
            let newAtt = AttractionInformation_Database()
            newAtt.AttractionName = attractionsmall.attractionName
            newAtt.AttractionLocation_Lan = attractionsmall.attractionLocation.latitude
            newAtt.AttractionLocation_Lon = attractionsmall.attractionLocation.longitude
            
            if let image = attractionsmall.attractionImageName{
                newAtt.AttractionImg = image
            } else {
                newAtt.AttractionImg = "attraction_default"
            }
            attractionsDB.append(newAtt)
        }
        
        return attractionsDB
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
        
        if editingStyle == .delete{
            self.plan?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            self.saveData()
        }
    }

}

// this extentsion creates the bridge between the this class and plan detail view class  - Wanfang Zhou 23/04/2019
extension PlanViewController : PlanCityViewControllerDelegate {
    func updateDestinations(_ controller: PlanCityViewController, cities: [CityListInformation], indexNum: Int) {
        
        if let plan = self.plan?[indexNum]{
            plan.City = cities
            self.tableView.reloadData()
            
        }
    }
}

// this extension is allow user to add memo to current plan
extension PlanViewController : MemoViewControllerDelegate {
    func updateMemoInformation(_ controller: MemoViewController, memo: String, indexNumber: Int) {
        
        if let plans = self.plan{
            plans[indexNumber].memo = memo
        }
    }
    
    
}
