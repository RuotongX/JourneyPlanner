//
//  PlanDetailViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 22/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

protocol PlanDetailViewControllerDelegate {
    
}

// this class is used to define the plan deail vie controller
class PlanDetailViewController: UIViewController {
    
    // the plan type is used to maintain the status of a view controller, if the status is set to normal then the add button will be avaible, otherwise it will be hide
    var PlanType : planType = .NORMAL
    var city: CityListInformation?
    var delegate : PlanDetailViewControllerDelegate?
    var editingMode : Bool = false
    @IBOutlet weak var CityNameLabel: UILabel!
    @IBOutlet weak var detailTableview: UITableView!
    
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    // this method is called when user first enter this view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableview.dataSource = self
        detailTableview.delegate = self
        
        if let cityInfo = city{
            CityNameLabel.text = cityInfo.cityName
        }
        
        if PlanType == .HISTORY{
            StartButton.isHidden = true
            addButton.isHidden = true
        }

        // Do any additional setup after loading the view.
    }
    
    // this method is used when pass value from this class to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // when user want to see the attraction detail, or pressed the button, it will display the relavent page for user
        if segue.identifier == "attractionDetail"{
            if let  TripdetailViewController = segue.destination as? tripDetailViewController{
                
                if let cell = sender as? UITableViewCell{
                    if let indexPath = detailTableview.indexPath(for: cell){
                        
                        if let cityInfo = self.city{
                            TripdetailViewController.delegate = self
                            TripdetailViewController.attraction = cityInfo.Attractions?[indexPath.row-2]
                            TripdetailViewController.indexNumber = indexPath.row - 2
                            
                            if PlanType == .HISTORY{
                                TripdetailViewController.Plantype = .HISTORY
                            }
                        }
                    }
                }
            }
        }
        
        // if user want to create new attraction on the plan, it will allow user to a viewpage and fill information
        if segue.identifier == "attractionNew"{
            if let  TripdetailNewViewController = segue.destination as? tripDetailViewController{
                TripdetailNewViewController.delegate = self

            }
        }
        
        // this method is used when user pressed the start button and entering the direction page
        if segue.identifier == "getDirection"{
            if let planMapViewController = segue.destination as? PlanMapViewController{
                if let city = self.city{
                    if let attractions = city.Attractions{
                        
                        if attractions.count == 0 {
                            let alert = UIAlertController(title: "Cannot Start", message: "Please add some attraction to continue", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(okAction)
                            self.present(alert,animated: true)
                        } else {
                            planMapViewController.attractionInformations = attractions
                        }
                    }
                }
            }
        }
    }
    // when statr button is pressed, do the following action, in here thiere is nothing to do, see prepare for more information
    @IBAction func StartButtonPressed(_ sender: Any) {
    }
    
    // this method is used to request the light content to the complier
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    // this method is used when the return button pressed, it will goback to the previous page1
    @IBAction func retunButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // when user pressed the swap button, it will change the status of tableview to editing mode
    @IBAction func SwapButtonPressed(_ sender: Any) {
        
        self.detailTableview.isEditing = !self.detailTableview.isEditing
        
    }
}
// this method is used to passing value between this view controller and trip detail view controller
extension PlanDetailViewController : tripDetailViewControllerDelagate{
    // user update attraction
    func didupdateAttraction(_ controller: tripDetailViewController, attraction: AttractionInformation, indexNumber: Int) {
        
        if let cityInfo = self.city{
            cityInfo.Attractions?.remove(at: indexNumber)
            cityInfo.Attractions?.insert(attraction, at: indexNumber)
        }
        self.detailTableview.reloadData()
    }
    
    // user add new attraction
    func didAddAttraction(_ controller: tripDetailViewController, attraction: AttractionInformation) {
        
        if let cityinfo = self.city{
            
            if cityinfo.Attractions == nil{
                cityinfo.Attractions = []
            }
            
            cityinfo.Attractions?.append(attraction)
        }
        self.detailTableview.reloadData()

    }
    
    
}

// this extension is used to maintain everything about the tableview
extension PlanDetailViewController : UITableViewDelegate, UITableViewDataSource{
    // when user pressed the tableview, it will not stuck on the selected mode
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // this method is used to allow user to swipe to delete city information
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            if let city = self.city{
                city.Attractions?.remove(at: indexPath.row-2)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
        }
    }
    
    // this method is return about wether this class can be modified or not
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    // this method is used to allow user to swap the arrangement of cells
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let cities = self.city{
            
            guard let att = cities.Attractions?[sourceIndexPath.row-2] else { return }
            
            cities.Attractions?.remove(at: sourceIndexPath.row-2)
            cities.Attractions?.insert(att, at: destinationIndexPath.row-2)
        }
    }
    // row 1 and row 2 cannot move around
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 || indexPath.row == 1{
            return false
        }
        return true
    }
    
    
    
    // do not cell to move to the first and second row
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if proposedDestinationIndexPath.row == 0  || proposedDestinationIndexPath.row == 1{
            return sourceIndexPath
        }
        
        return proposedDestinationIndexPath
    }
    
    // this method is used to return how many items available in the table, in here,first 2 is fixed and cannot be changed.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let cityinfo = self.city{
            if let attraction = cityinfo.Attractions{
                return 2+attraction.count
            }
        }
        
        return 2
    }
    // this method is used to return the tableview height, the height is different for each component, it can be identified in here
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 65
        } else if indexPath.row == 1{
            return 188
        }
        
        return 128
    }
    
    // this method is used to customize the cell type.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // first cell is the length of a single trip
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "stayLength", for: indexPath) as? PlanDetailStayLengthTableViewCell else {fatalError("Unable to convert to stayLengthCell")}
            
            if let cityinfo = self.city{
                
                cell.StayLength.text = "\(cityinfo.cityStopTime) Day Trip"
            }
            
            return cell
            // second cell will display relavent map information
        } else if indexPath.row == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "planDetailMap", for: indexPath) as? PlanDetailMapTableViewCell else {fatalError("Unable to convert to plandetailmaptableviewcell")}
            
            cell.map.layer.cornerRadius = 8
            
            if let city = self.city{
                cell.displayRegion(coordinates: city.cityLocation)
                
                if let attractions = city.Attractions{
                    var AnnotationCoordinates : [CLLocationCoordinate2D] = []
                    
                    for attraction in attractions{
                        AnnotationCoordinates.append(attraction.attractionLocation)
                    }
                    
                    cell.loadAnnotations(coordinates: AnnotationCoordinates)
                }
                
            }
            
            return cell
        }
        
        // following method will be normal attraction information.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "attractions", for: indexPath) as? AttractionDetailTableViewCell else {fatalError("Unable to convert to AttractionDetailTableViewCell")}
        
        
        if let cityInfo = self.city{
            if let attractions = cityInfo.Attractions{
                let attraction = attractions[indexPath.row - 2]
                
                cell.AttractionName.text = attraction.attractionName
                
                if let attractionImage = attraction.attractionImage{
                    cell.AttractionImage.image = attractionImage
                } else{
                    if let defaultImg = UIImage(named: "attraction_default"){
                        cell.AttractionImage.image = defaultImg
                    }
                }
                
                let geocoder : CLGeocoder = CLGeocoder()
                var address : String = ""
                
                geocoder.reverseGeocodeLocation(CLLocation(latitude: attraction.attractionLocation.latitude, longitude: attraction.attractionLocation.longitude)) { (placemark, error) in
                    
                    if let error = error{
                        print("Unable to convert coordinates to address information")
                        print(error.localizedDescription)
                    }
                    
                    if let placemark = placemark{
                        let locationInfo = placemark.first
                        
                        if let streetNo = locationInfo?.subThoroughfare{
                            address.append(streetNo)
                        }
                        if let street = locationInfo?.thoroughfare{
                            if address.isEmpty == false{
                                address.append(" ")
                            }
                            address.append("\(street)")
                        }
                        if let suburb = locationInfo?.subLocality{
                            if address.isEmpty == false{
                                address.append(", ")
                            }
                            address.append("\(suburb)")
                        }
                        if let city = locationInfo?.locality{
                            if address.isEmpty == false{
                                address.append(", ")
                            }
                            address.append("\(city)")
                        }
                        
                    } else {
                        address = "Unknown Coordinate Information!"
                    }
                    
                    cell.AttractionAddress.text = address
                }
            }
        }

        return cell
    }
    
    
}




