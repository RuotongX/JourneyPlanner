//
//  PlanDetailMapTableViewCell.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 23/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// this method is used to define the map cell in the trip view page
class PlanDetailMapTableViewCell: UITableViewCell {

    @IBOutlet weak var map: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // this method i scalled to diaplay the region of a certain city
    func displayRegion(coordinates: CLLocationCoordinate2D){
        
        let regionRadius : CLLocationDistance = 8000.0
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        map.setRegion(region, animated: false)
    }

    // this method is called to load annotation from location coordinate to the annotation and drop on the map 
    func loadAnnotations(coordinates: [CLLocationCoordinate2D]){
        map.removeAnnotations(map.annotations)
        
        for singleCoordinate in coordinates{
            let annotation = MKPointAnnotation()
            annotation.coordinate = singleCoordinate
            map.addAnnotation(annotation)
        }
    }
}
