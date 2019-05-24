//
//  RoutePreviewController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 24/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

class RoutePreviewController: UIViewController {

    @IBOutlet weak var RoutePreviewTableview: UITableView!
    
    var previewData : [AttractionInformation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = UIImage(named: "Trip-Piha_90_2x"){
            let infor_1 = AttractionInformation.init(Name: "Piha", Location: CLLocationCoordinate2D(latitude: -36.954 , longitude: 174.471), attractionImage: image)
            
            previewData.append(infor_1)
        }
        
        if let image2 = UIImage(named: "Trip-SkyTower-90-1x"){
            let infor_2 = AttractionInformation.init(Name: "Sky Tower", Location: CLLocationCoordinate2D(latitude: -36.848461 , longitude: 174.762183), attractionImage: image2)
            
            previewData.append(infor_2)
        }
        
        RoutePreviewTableview.dataSource = self
        RoutePreviewTableview.delegate = self
    }
}

extension RoutePreviewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return previewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoutePreviewCell", for: indexPath) as? RoutePreviewCell else {fatalError("The dequeued cell is not an instance of RoutePreviewCellTableViewCell")
        }
        
        cell.PreviewName.text = previewData[indexPath.row].attractionName
        
        cell.PreviewImage.image = previewData[indexPath.row].attractionImage
        
    cell.PreviewImage.layer.cornerRadius = cell.PreviewImage.frame.height / 2
        
        return cell
    }
}
