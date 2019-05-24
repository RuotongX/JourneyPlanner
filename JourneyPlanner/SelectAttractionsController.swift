//
//  SelectAttractionsController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 24/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

class SelectAttractionsController: UIViewController {

    @IBOutlet weak var CityName: UILabel!
    
    
    @IBAction func ReturnButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var AttractionTableview: UITableView!
    
    var AttractionData : [AttractionInformation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image1 = UIImage(named: "Trip-Piha_90_2x"){
            let infor_1 = AttractionInformation.init(Name: "Piha Beach", Location: CLLocationCoordinate2D(latitude: 174.471, longitude: -36.954), attractionImage: image1)
            
            AttractionData.append(infor_1)
        }
        
        if let image2 = UIImage(named: "Trip-SkyTower-90-1x"){
            let infor_2 = AttractionInformation.init(Name: "Auckland Sky Tower", Location: CLLocationCoordinate2D(latitude: 174.76, longitude: -36.85), attractionImage: image2)
            
            AttractionData.append(infor_2)
        }
        
        if let image3 = UIImage(named: "Trip-Waihike-90-1x"){
            let infor_3 = AttractionInformation.init(Name: "Waihike Island", Location: CLLocationCoordinate2D(latitude: 175.1, longitude: -16.8), attractionImage: image3)
            
            AttractionData.append(infor_3)
        }

        AttractionTableview.dataSource = self
        AttractionTableview.delegate = self
    }
}

extension SelectAttractionsController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AttractionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectAttractionsCell", for: indexPath) as? SelectAttractionsCell else{
            fatalError("The dequeued cell is not an instance of SelectCityCell.")
        }
        
        cell.AttractionName.text = AttractionData[indexPath.row].attractionName
        
        cell.AttractionsImage.image = AttractionData[indexPath.row].attractionImage
        
        cell.AttractionsImage.layer.cornerRadius = cell.AttractionsImage.frame.height / 2
        
        cell.Background.layer.cornerRadius = 20
        
        return cell
    }
}
