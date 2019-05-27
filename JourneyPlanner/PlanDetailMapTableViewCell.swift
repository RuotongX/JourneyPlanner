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
    
    func displayRegion(coordinates: CLLocationCoordinate2D){
        
        let regionRadius : CLLocationDistance = 2000.0
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        map.setRegion(region, animated: false)
    }

    func loadAnnotations(coordinates: [CLLocationCoordinate2D]){
        map.removeAnnotations(map.annotations)
        
        for singleCoordinate in coordinates{
            let annotation = MKPointAnnotation()
            annotation.coordinate = singleCoordinate
            map.addAnnotation(annotation)
        }
    }
}
