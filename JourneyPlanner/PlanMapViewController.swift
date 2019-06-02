//
//  PlanMapViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 2/06/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PlanMapViewController: UIViewController {

    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var AttractionNameLabel: UILabel!
    
    var selectedLocationCoordinate : CLLocationCoordinate2D?
    var selectedLocationName : String?
    var attractionInformations : [AttractionInformation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapview.delegate = self
        loadUserPreffredMap()
        dropAnnotations()
        displayRegion()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AddRoute()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    private func displayRegion(){
        
        if let attractions = self.attractionInformations{
            if let firstAttraction = attractions.first{
                
                let regionRadius : CLLocationDistance = 2000.0
                let region = MKCoordinateRegion(center: firstAttraction.attractionLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                
                mapview.setRegion(region, animated: true)
            }
        }
        
    }
    
    private func AddRoute(){
        
        if let attractions = self.attractionInformations{
            
            guard attractions.count != 1 else {return}
            
            for(index,attraction) in attractions.enumerated(){
                
                if index + 1 != attractions.count{
                    let sourcePlacemark = MKPlacemark(coordinate: attraction.attractionLocation)
                    let destinationPlacemark = MKPlacemark(coordinate: attractions[index + 1].attractionLocation)
                    
                    let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                    let destinationItem = MKMapItem(placemark: destinationPlacemark)
                    
                    let directionRequest = MKDirections.Request()
                    directionRequest.source = sourceMapItem
                    directionRequest.destination = destinationItem
                    
                    let directionRespons = MKDirections(request: directionRequest)
                    
                    directionRespons.calculate { (result, error) in
                        guard let response = result else{
                            if let error = error{
                                print(error.localizedDescription)
                            }
                            return
                        }
                        
                        let route = response.routes[0]
                        self.mapview.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                    }
                }
            }
            
        }
    }
    
    
    private func loadUserPreffredMap(){
        
        let preferredMapID = UserDefaults.standard.integer(forKey: "MapType")
        
        if preferredMapID == 0 {
            mapview.mapType = .standard
        } else if preferredMapID == 1{
            mapview.mapType = .satellite
        } else if preferredMapID == 2{
            mapview.mapType = .hybrid
        } else {
            mapview.mapType = .standard
        }
    }
    private func dropAnnotations(){
        
        self.mapview.removeAnnotations(mapview.annotations)
        
        if let attractions = self.attractionInformations{
            for (index,attraction) in attractions.enumerated(){
                let annotation = MKPointAnnotation()
                annotation.coordinate = attraction.attractionLocation
                annotation.title = attraction.attractionName
                annotation.subtitle = "\(index + 1)"
                self.mapview.addAnnotation(annotation)
            }
        }
    }
    
    @IBAction func ExitButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func DirectionButtonPressed(_ sender: Any) {
        
        if let coordinate = self.selectedLocationCoordinate,
            let placeName = self.selectedLocationName{
            
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = placeName
            mapItem.openInMaps(launchOptions: nil)
        } else {
            let alert = UIAlertController(title: "Select Attraction", message: "Please select one attraction to continue", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true)
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

extension PlanMapViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation{
            self.AttractionNameLabel.text = annotation.title!
            self.selectedLocationCoordinate = annotation.coordinate
            self.selectedLocationName = annotation.title!
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.orange
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let _ = annotation as? MKUserLocation{
            return nil
        }
        
        
        // this method allow annotation to clustered together
        if let cluster = annotation as? MKClusterAnnotation{
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "cluster") as? MKMarkerAnnotationView
            if annotationView == nil{
                annotationView = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: "cluster")
            }
            annotationView?.markerTintColor = UIColor.brown
            annotationView?.annotation = cluster
            return annotationView
        }
        
       
        let identifier = "marker"
        var view : MKMarkerAnnotationView
        
        // this method is defining the normal annotations
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = false
            view.clusteringIdentifier = "cluster"
            
            view.glyphText = annotation.subtitle!
        }
        return view
        
        
    }
    
}
