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
    
}

class tripDetailViewController: UIViewController {
    
    var delegate : tripDetailViewControllerDelagate?
    var attraction : AttractionInformation?

    @IBOutlet weak var TripTitle: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var TripNameTextField: UITextField!
    
    // this method is called after this view is loaded - Wanfang Zhou  30/04/2019
    override func viewDidLoad() {
        super.viewDidLoad()

        loadInformation()

    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    private func loadInformation(){
        
        if let attraction = self.attraction{
            TripTitle.text = attraction.attractionName
            TripNameTextField.text = attraction.attractionName
            addMapAnnotation(location: attraction.attractionLocation)
        }
    }
    
    // this function is designed to passing value to another class - Wanfang Zhou  30/04/2019
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "searchTripOnMap"{
//            if let uiNavigationController = segue.destination as? UINavigationController{
//                if let mapViewController = uiNavigationController.viewControllers.first as? MapViewController{
//                    mapViewController.delegate = self
//                    mapViewController.mapsource = .PLANDETAIL_ADDNEW
//                    if let plan = trip{
//                        mapViewController.planDetail_planInformation = plan.location
//                        mapViewController.mapsource = .PLANDETAIL_VIEW
//                    }
//                }
//
//            }
//        }
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
        mapView.setRegion(region, animated: true)
    }
    


    
    // if user presee the return button, it will return to the previous page - Wanfang Zhou  30/04/2019
    @IBAction func returnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

