//
//  MapViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 23/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

protocol MapViewControllerDelegate: class{
    
}

class MapViewController: UIViewController {

    var resultSearchController : UISearchController?
    var selectedCity: LocationInformation?
    var delegate: MapViewControllerDelegate?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // change the current location icon to black Dalton 23/Apr/2019
        
        addSearchController()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadInformation()
    }
    
    
    func addSearchController(){
        // load the table view and define it as searchresult tableview Dalton 24/Apr/2019
        
        // ResultTable -> SearchResultController -> UIsearchController. Dalton 24/Apr/2019
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "SearchMapTableViewController") as! SearchMapTableViewController
        locationSearchTable.mapView = self.mapView
        
        //resultSearchController -> UISearchController Dalton 24/Apr/2019
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search For Places"
        
        // set the title bar to this searchbar (connect two component together) Dalton 24/Apr/2019
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        
        // set this to true can avoid the screen to be totally covered by the table view, by set this to true, it will only cover the part other than search bar - Dalton 24/Apr/2019
        definesPresentationContext = true
    }
    
    private func loadInformation(){
        
        if let selectedCity = selectedCity{
            // if user did not provide location information, then this app will not display the current user location.Dalton 23 Apr 2019
            if selectedCity.cityName == "Unknown"{
                let alertController : UIAlertController = UIAlertController(title: "Unknown Location", message: "Unable to get your location, please allow this app to obtain your current location", preferredStyle: .alert)
                let alertAction : UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                
                // if user provide the current location, this will display the nearst 500 memter surroudings to user.Dalton 23 Apr 2019
            } else {
                let regionRadius : CLLocationDistance = 500.0
                let center : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: selectedCity.location.coordinate.latitude, longitude: selectedCity.location.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    
    //This class is used to define the action of segment, when the segment is changed, the type of map will be changed. Dalton 23 Apr 2019
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            mapView.mapType = .standard
        } else if sender.selectedSegmentIndex == 1{
            mapView.mapType = .satellite
        } else if sender.selectedSegmentIndex == 2{
            mapView.mapType = .hybrid
        }
    }
    
    
    @IBAction func ReturnButtonPressed(_ sender: UIButton) {
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




