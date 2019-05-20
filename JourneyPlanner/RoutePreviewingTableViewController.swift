//
//  RoutePreviewingTableViewController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 16/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class RoutePreviewingTableViewController: UITableViewController {
    
    var previewInformation : [AttractionInformation] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return previewInformation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "previewCell", for: indexPath) as? RoutePreviewCellTableViewCell else{fatalError("The dequeued cell is not an instance of RoutePreviewCellTableViewCell.")}
        
        cell.AttractionName.text = previewInformation[indexPath.row].attractionName
        
        cell.AttractionsImage.image = previewInformation[indexPath.row].attractionImage
        
        cell.AttractionsImage.layer.cornerRadius = cell.AttractionsImage.frame.height / 2
        
        return cell
    }
}
