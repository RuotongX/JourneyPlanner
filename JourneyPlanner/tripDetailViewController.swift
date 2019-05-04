//
//  tripDetailViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 29/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol tripDetailViewControllerDelagate : class{
    func didUpdatePlan(_ controller: tripDetailViewController, trip : SmallTripInformation, oldTrip : SmallTripInformation, position : Int)
    
    func didNewPlan(_ controller: tripDetailViewController, trip:SmallTripInformation)
    
    
}

class tripDetailViewController: UIViewController {
    
    var delegate : tripDetailViewControllerDelagate?
    var trip : SmallTripInformation?
    var oldtrip : SmallTripInformation?
    var oldtripNumber : Int?
    
    @IBOutlet weak var TimeSpentLabel: UILabel!
    @IBOutlet weak var RatingLabel: UILabel!
    
    @IBOutlet weak var TripTitle: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var MemoTextField: UITextField!
    @IBOutlet weak var StayLengthTextField: UITextField!
    @IBOutlet weak var TripNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let plan = trip{
            loadPlan(plan: plan)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchTripOnMap"{
            if let uiNavigationController = segue.destination as? UINavigationController{
                if let mapViewController = uiNavigationController.viewControllers.first as? MapViewController{
                    mapViewController.delegate = self
                    mapViewController.mapsource = .PLANDETAIL_ADDNEW
                    if let plan = trip{
                        mapViewController.planDetail_planInformation = plan.location
                        mapViewController.mapsource = .PLANDETAIL_VIEW
                    }
                }
                
            }
        }
    }
    
    private func loadPlan(plan:SmallTripInformation){
        TripTitle.text = "My Trip"
        TripNameTextField.text = plan.name
        StayLengthTextField.text = "\(plan.staylength)"
        MemoTextField.text = plan.memo
        
        RatingLabel.text = "No Information Available"
        TimeSpentLabel.text = ""
        
        addMapAnnotation(location: plan.location)
    }
    
    private func addMapAnnotation(location: CLLocation){
        mapView.isHidden = false
        
    mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func addAllNecessaryData(){
        
        self.trip?.name = TripNameTextField.text ?? ""
        self.trip?.memo = MemoTextField.text
        
        if let stayLength = StayLengthTextField.text{
            self.trip?.staylength = Int(stayLength) ?? 0
        }
    }
    
    @IBAction func DoneButton(_ sender: Any) {
        
        if let trip = trip{
            if let oldTrip = self.oldtrip,
                let tripnumber = self.oldtripNumber{
                addAllNecessaryData()
                self.delegate?.didUpdatePlan(self, trip: trip, oldTrip: oldTrip, position: tripnumber)
            } else{
                addAllNecessaryData()
                self.delegate?.didNewPlan(self, trip: trip)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func returnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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


extension tripDetailViewController : MapViewControllerDelegate{
    // this one is related to this class, when user is select a new location, user can replace the old one. - Dalton 02/May/2019
    func didSelectANewLocation(_ controller: MapViewController, selectedLocation: CLLocation, nameOfLocation: String) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(selectedLocation) { (placemarks, error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                let placemark = placemarks?.first
                
                let placeName = nameOfLocation
                
                if let location = placemark?.location{
                    
                    // if there is an existing plan, this means it was replace the old trip with new trips - Dalton 03/May/2019
                    if let trip = self.trip{
                        self.oldtrip = trip
                    }
                    self.MemoTextField.text = ""
                    
                    self.trip = SmallTripInformation(name: placeName, location: location, staylength: 0, arrangement: 0)
                    
                    self.loadPlan(plan: self.trip!)
                }
            }
        }
    }
    
    
    func didSelectANewcity(_ controller: MapViewController, selectedCity: LocationInformation) {
        // do nothing since it is not relate to this class, see select city for more information - Dalton 02/May/2019
    }
    
    
    
}
