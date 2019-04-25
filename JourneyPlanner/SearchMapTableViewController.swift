//
//  SearchTableViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 24/04/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//


// This is a class which define the tableview controller of search function - Dalton 24/Apr/2019

import UIKit
import MapKit

class SearchMapTableViewController: UITableViewController {

    var mapView : MKMapView?
    var matchingItems : [MKMapItem] = []
    
    func conversionToAddress(place : CLPlacemark) -> String{
        
        var address : String = ""
        
        // add street number
        if let StreetNumber = place.subThoroughfare {
            address.append("\(StreetNumber) ")
        }else{}
        
        // add street
        if let Street = place.thoroughfare{
            address.append("\(Street) ")
        }else{}
        
        // add suburb
        if let Suburb = place.subLocality{
            address.append("\(Suburb) ")
        }else{}
        
        // add city
        if let City = place.locality{
            address.append("\(City) ")
        }else{}
   
        return address
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")
        
        let locationName = matchingItems[indexPath.row].placemark.name
        cell?.textLabel?.text = locationName
        cell?.detailTextLabel?.text = conversionToAddress(place:matchingItems[indexPath.row].placemark)
        return cell!
    }

}

extension SearchMapTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // make sure there is a mapview and there is a keyword
        guard let mapView = mapView,
              let searchKeyWord = searchController.searchBar.text else { return }
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchKeyWord
        searchRequest.region = mapView.region
        
        let result : MKLocalSearch = MKLocalSearch(request: searchRequest)
        
        result.start { (response, error) in
            guard let response = response else {return}
            
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }

        
    }
}
