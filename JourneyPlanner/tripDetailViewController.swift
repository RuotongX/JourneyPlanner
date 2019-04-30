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
    
}

class tripDetailViewController: UIViewController {
    
    var delegate : tripDetailViewControllerDelagate?
    var plan : SmallPlanInformation?
    
    @IBOutlet weak var TimeSpentLabel: UILabel!
    @IBOutlet weak var RatingLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var MemoTextField: UITextField!
    @IBOutlet weak var StayLengthTextField: UITextField!
    @IBOutlet weak var TripNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let plan = plan{
            loadPlan(plan: plan)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchTripOnMap"{
            if let uiNavigationController = segue.destination as? UINavigationController{
                if let mapViewController = uiNavigationController.viewControllers.first as? MapViewController{
                    mapViewController.delegate = self
                    
                    if let plan = plan{
                        mapViewController.singleLocation = plan.location
                    }
                }
                
            }
        }
    }
    
    private func loadPlan(plan:SmallPlanInformation){
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
    
    @IBAction func DoneButton(_ sender: Any) {
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
    
}
