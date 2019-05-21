//
//  RoutePreviewController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 21/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

class RoutePreviewController: UIViewController {
    
    
    @IBOutlet weak var PreviewTableview: UITableView!
    var attractionsInfor : [AttractionInformation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "Trip-Piha_90_2x"){
            let infor_1 = AttractionInformation.init(Name: "Piha", Location: CLLocationCoordinate2D(latitude: -36.954 , longitude: 174.471), Image: image)
            
            attractionsInfor.append(infor_1)
        }
        
        if let image2 = UIImage(named: "Trip-SkyTower-90-1x"){
            let infor_2 = AttractionInformation.init(Name: "Sky Tower", Location: CLLocationCoordinate2D(latitude: -36.848461 , longitude: 174.762183), Image: image2)
            
            attractionsInfor.append(infor_2)
        }

        PreviewTableview.dataSource = self
        PreviewTableview.delegate = self
    }
}

extension RoutePreviewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return attractionsInfor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoutePreviewCell", for: indexPath) as? RoutePreviewCellTableViewCell else {fatalError("The dequeued cell is not an instance of RoutePreviewCellTableViewCell")
        }
        
        cell.AttractionsName.text = attractionsInfor[indexPath.row].attractionName
        cell.AttractionsImage.image = attractionsInfor[indexPath.row].attractionImage
        
        return cell
    }
}
