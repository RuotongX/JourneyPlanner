//
//  tripDetailViewController.swift
//  JourneyPlanner
//
//  Created by Wanfang Zhou on 29/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// this method is created to allow the information passing from this page to another detail page - Wanfang Zhou  30/04/2019
protocol tripDetailViewControllerDelagate : class{
    func didupdateAttraction(_ controller: tripDetailViewController,attraction:AttractionInformation,indexNumber:Int)
    func didAddAttraction(_ controller: tripDetailViewController, attraction: AttractionInformation)
}

class tripDetailViewController: UIViewController {
    
    var delegate : tripDetailViewControllerDelagate?
    var attraction : AttractionInformation?
    var Plantype : planType = .NORMAL
    var indexNumber : Int?

    @IBOutlet weak var SearchOnMapButton: UIButton!
    @IBOutlet weak var TripTitle: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var TripNameTextField: UITextField!
    
    // this method is called after this view is loaded - Wanfang Zhou  30/04/2019
    override func viewDidLoad() {
        super.viewDidLoad()
        TripNameTextField.delegate = self
        
        if Plantype == .HISTORY{
            self.TripNameTextField.isEnabled = false
            self.SearchOnMapButton.isEnabled = false
        }
    }
    //this method will be called everytime when user enter the viewcontroller
    override func viewDidAppear(_ animated: Bool) {
        loadInformation()

    }
    // this method is change the status bar from the dark content to light content
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    // this method is used to load the attraction information from the previous page and load it in the current page
    private func loadInformation(){
        
        if let attraction = self.attraction{
            TripTitle.text = attraction.attractionName
            TripNameTextField.text = attraction.attractionName
            addMapAnnotation(location: attraction.attractionLocation)
        }
    }
    
    // this function is designed to passing value to another class - Wanfang Zhou  30/04/2019
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchTripOnMap"{
            if let uiNavigationController = segue.destination as? UINavigationController{
                if let mapViewController = uiNavigationController.viewControllers.first as? MapViewController{
                    mapViewController.delegate = self
                    mapViewController.mapsource = .PLANDETAIL
                    if let attractionInfo = attraction{
                        mapViewController.plandetail_attractionInformation = attractionInfo
                    }
                }

            }
        }
    }
    
    // this function is used to load the trip, to set up all essential labels - Wanfang Zhou  30/04/2019

    
    // this method is used to display the small window on the view trip detail page, it will show annotation on the map and zoom to selected area - Wanfang Zhou  30/04/2019 work with Qijin Chen 30/04/2019
    private func addMapAnnotation(location: CLLocationCoordinate2D){
        mapView.isHidden = false
        
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        
        mapView.addAnnotation(annotation)
        
        let span = CLLocationDistance(1000.0)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: span, longitudinalMeters: span)
        mapView.setRegion(region, animated: false)
    }
    
    //while the done button is pressed, this attraction information will be saved to the database
    @IBAction func DoneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            
            if let delegate = self.delegate,
                let attraction = self.attraction{
                if let indexnumber = self.indexNumber{
                    attraction.attractionName = self.TripNameTextField.text!
                    delegate.didupdateAttraction(self, attraction: attraction, indexNumber: indexnumber)
                } else{
                    delegate.didAddAttraction(self, attraction: attraction)
                }
            }
        }
    }
    

    
    // if user presee the return button, it will return to the previous page - Wanfang Zhou  30/04/2019
    @IBAction func returnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension tripDetailViewController:UITextFieldDelegate{
    // when press return, the keyboard will automatically hide
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TripNameTextField.resignFirstResponder()
        return true
    }
    // when press background, keyboard will hide
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension tripDetailViewController: MapViewControllerDelegate{
    func didSelectANewcity(_ controller: MapViewController, selectedCity: LocationInformation) {
        // do not implement this method, it does not relate to this class
    }
    
    // if user select a new location from the mapview controller, it will be update on this class.
    func didSelectANewLocation(_ controller: MapViewController, selectedLocation: CLLocation, nameOfLocation: String) {
        let newAttraction = AttractionInformation(Name: nameOfLocation, Location: CLLocationCoordinate2D(latitude: selectedLocation.coordinate.latitude, longitude: selectedLocation.coordinate.longitude))
        
        self.attraction = newAttraction
    }
    
    
}
