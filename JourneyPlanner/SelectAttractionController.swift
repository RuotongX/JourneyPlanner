//
//  SelectAttractionController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 23/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

class SelectAttractionController: UIViewController {

    var AttractionData : [AttractionInformation] = []
    
    @IBOutlet weak var CityNmae: UILabel!
    
    @IBOutlet weak var AttractionList: UITableView!
    
    @IBAction func ReturnButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
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
        
        AttractionList.dataSource = self
        AttractionList.delegate = self
    }
}

extension SelectAttractionController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AttractionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectAttractionCell", for: indexPath) as? SelectAttractionCell else{
            fatalError("The dequeued cell is not an instance of SelectCityCell.")
        }
        
        cell.AttractionName.text = AttractionData[indexPath.row].attractionName
        
        cell.AttractionImage.image = AttractionData[indexPath.row].attractionImage
        
        cell.AttractionImage.layer.cornerRadius = cell.AttractionImage.frame.height / 2
        
        cell.Background.layer.cornerRadius = 20
        
//        tableView.allowsMultipleSelection = true
//
//        let selsectIndexPath = tableView.indexPathsForSelectedRows
//        let rowSelected = selsectIndexPath != nil && selsectIndexPath!.contains(indexPath)
//
//        cell.accessoryType = rowSelected ? .checkmark : .none
//
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { d
//            let cell = tableView.cellForRow(at: indexPath)!
//            cell.accessoryType = .checkmark
//        }
//
//        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//            let cell = tableView.cellForRow(at: indexPath)!
//            cell.accessoryType = .none
//        }
//
//        let selectedRows = tableView.indexPathsForSelectedRows
        
      
        
        return cell
    }
}
