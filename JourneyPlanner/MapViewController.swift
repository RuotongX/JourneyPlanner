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
    func didSelectANewcity(_ controller: MapViewController, selectedCity : LocationInformation)
}

enum MapSource{
    case HOMEPAGE_MAP
    case HOMEPAGE_SEARCH
    case PLANDETAIL
    case CHANGECITY
    case EXPLOREPAGE
    
    
}

class MapViewController: UIViewController {
    
    
    var selectedAnnotation : MKAnnotation?
    var changeCity_CurrentCity : LocationInformation?
    var changeCity_ReturnValue : LocationInformation?
    

//    var selectedAnnotation : MKPlacemark? = nil
    var mapsource : MapSource? = .CHANGECITY
    var annotationPin : MKPlacemark? = nil
    var resultSearchController : UISearchController?
    var selectedCity: LocationInformation?
    var singleLocation : CLLocation?
    var delegate: MapViewControllerDelegate?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // change the current location icon to black Dalton 23/Apr/2019
        
        addSearchController()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadInformation()
        
        mapView.delegate = self
    }
    @objc func showActionSheet(){
        
        if let mapsource = mapsource{
            
            let alertSheet = UIAlertController(title: "Choose an action", message: "Choose an action to continue", preferredStyle: .actionSheet)
            
            if mapsource == .CHANGECITY{
                
                let changeCtiyAction = UIAlertAction(title: "Replace with Current City", style: .default) { (action) in
                    
                    if let selectedPlace:MKAnnotation = self.selectedAnnotation{
                        
                        let geocoder = CLGeocoder()
                        let location : CLLocation = CLLocation(latitude: selectedPlace.coordinate.latitude, longitude: selectedPlace.coordinate.longitude)
                        
                        geocoder.reverseGeocodeLocation(location
                            , completionHandler: { (placemarks, error) in
                                if let error = error{
                                    print(error.localizedDescription)
                                } else{
                                    if let placeMark = placemarks?.first{
                                        
                                        if let cityName = placeMark.subLocality{
                                            if let zipCode = placeMark.postalCode{
                                                
                                                let cityInformation = LocationInformation(cityName: cityName, lontitude: location.coordinate.longitude, latitude: location.coordinate.latitude, zipCode: zipCode)
                                                
                                                self.delegate?.didSelectANewcity(self, selectedCity: cityInformation)
                                                self.dismiss(animated: true, completion: nil)
                                            }
                                        }
                                    }
                                }
                        })
                        
                    }
                }
                alertSheet.addAction(changeCtiyAction)
                
            } else if mapsource == .HOMEPAGE_MAP{
                
                let saveAction = UIAlertAction(title: "👌🏻 Add to Plan", style: .default) { (action) in
        
                }
                let favoriteAction = UIAlertAction(title: "😍 Favorite", style: .default) { (action) in
        
                }
        
                alertSheet.addAction(saveAction)
                alertSheet.addAction(favoriteAction)
            } else if mapsource == .PLANDETAIL{
                let replaceLocation = UIAlertAction(title: "Replace with existing Location", style: .default) { (action) in
                    
                }
                alertSheet.addAction(replaceLocation)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alertSheet.addAction(cancelAction)
            self.present(alertSheet,animated: true)

        }
        
        
        
       
        


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
        
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    // if user did not provide location information, then this app will not display the current user location.Dalton 23 Apr 2019
    private func errorMsgCannotObtainCurrentLocation(){
        let alertController : UIAlertController = UIAlertController(title: "Unknown Location", message: "Unable to get your location, please allow this app to obtain your current location", preferredStyle: .alert)
        let alertAction : UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func loadInformation(){
        
        if let mapsource = mapsource{
            if mapsource == .CHANGECITY{
                if let changeCity_CurrentCity = changeCity_CurrentCity{
                    if changeCity_CurrentCity.cityName == "Unknown"{
                        errorMsgCannotObtainCurrentLocation()
                    } else {
                        
                        // if user provide the current location or selected city, this will display the nearst 1000 memter surroudings to user. Dalton 23 Apr 2019, last modified 02 May 2019
                        
                        let regionRadius : CLLocationDistance = 1000.0
                        let center : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: changeCity_CurrentCity.location.coordinate.latitude, longitude: changeCity_CurrentCity.location.coordinate.longitude)
                        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                        
                        mapView.setRegion(region, animated: true)
                    }
                }
            }
        }
        
        
        
        
        // this call is from the plan detail class, which design to display the location in a map
        if let singleLocation = singleLocation{
            
            let placemark = MKPlacemark(coordinate: singleLocation.coordinate)
            
            dropPinZoomIn(placemark: placemark)
            
            //转换singlelocation 从 CLLocation to MK mark
//            mapView.removeAnnotations(mapView.annotations)
            
//            let annotation = MKPointAnnotation()
//            annotation.coordinate =  singleLocation.coordinate
//
//            mapView.addAnnotation(annotation)
//            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//            let region = MKCoordinateRegion(center: singleLocation.coordinate, span: span)
//            mapView.setRegion(region, animated: true)
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

}

extension MapViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation{
            self.selectedAnnotation = annotation
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let _ = annotation as? MKUserLocation{
            return nil
        }
        
        let identifier = "marker"
        var view : MKMarkerAnnotationView
        
        print("marker called")
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
            dequeuedView.annotation = annotation
            view = dequeuedView
            print("exist")
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            print("??")
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//
//            let smallSquare = CGSize(width: 30, height: 30)
//            let favoriteButton : UIButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
//            favoriteButton.setBackgroundImage(UIImage(named: "mapview -callOutAddButton 1x"), for: .normal)
            
            let detailButton: UIButton = UIButton(type: .detailDisclosure)
            detailButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
            view.rightCalloutAccessoryView = detailButton

//            view.glyphText = "🐷"
        }
        return view
    }
    


}

extension MapViewController : HandleMapSearch{
    func dropPinZoomIn(placemark: MKPlacemark) {
        annotationPin = placemark
        
        mapView.removeAnnotations(mapView.annotations)
        selectedAnnotation = placemark
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        
        if let annotationName = placemark.name{
            annotation.title = annotationName
        } else {
            annotation.title = "Selected Place"
        }
//        annotation.title = placemark.areasOfInterest?[0]
//        // 在这里少了个名字呀 所以他就不能显示callout
//            //placemark.name
        
        var subtitle : String = ""
        
        if let streetNo = placemark.subThoroughfare{
            subtitle.append("\(streetNo)")
        }
        if let street = placemark.thoroughfare{
            subtitle.append(" \(street)")
        }
        if let city = placemark.subLocality{
            subtitle.append(", \(city)")
        }
        
        annotation.subtitle = subtitle
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: placemark.coordinate,span: span)
        mapView.setRegion(region, animated: true)
    }
}

