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

class PlanDetailViewController: UIViewController {
    
    var PlanType : planType = .NORMAL
    var city: CityListInformation?
    var delegate : PlanDetailViewControllerDelegate?
    @IBOutlet weak var CityNameLabel: UILabel!
    @IBOutlet weak var detailTableview: UITableView!
    
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
        
        if segue.identifier == "attractionNew"{
            if let  TripdetailNewViewController = segue.destination as? tripDetailViewController{
                TripdetailNewViewController.delegate = self

            }
        }
    }
    @IBAction func StartButtonPressed(_ sender: Any) {
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func retunButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    
}
extension PlanDetailViewController : tripDetailViewControllerDelagate{
    func didupdateAttraction(_ controller: tripDetailViewController, attraction: AttractionInformation, indexNumber: Int) {
        
        if let cityInfo = self.city{
            cityInfo.Attractions?.remove(at: indexNumber)
            cityInfo.Attractions?.insert(attraction, at: indexNumber)
        }
        self.detailTableview.reloadData()
    }
    
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


extension PlanDetailViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let cityinfo = self.city{
            if let attraction = cityinfo.Attractions{
                return 2+attraction.count
            }
        }
        
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 65
        } else if indexPath.row == 1{
            return 188
        }
        
        return 128
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "stayLength", for: indexPath) as? PlanDetailStayLengthTableViewCell else {fatalError("Unable to convert to stayLengthCell")}
            
            if let cityinfo = self.city{
                
                cell.StayLength.text = "\(cityinfo.cityStopTime) Day Trip"
            }
            
            return cell
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




