//
//  SelectCityController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 20/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

protocol SelectCityControllerDelegate {
    
}

class SelectCityController: UIViewController {

    
    @IBAction func ReturnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var SelectCity: UITableView!
    
    var delegate: SelectCityControllerDelegate?
    var cityInformation : [CityListInformation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "Trip-Skytower-150*110-1x"){
            let location = CLLocationCoordinate2D(latitude: 174.7619066, longitude: -36.8484609)
            let infor_1 = CityListInformation(name: "Auckland", time: 1, location: location, image: image)
            
            cityInformation.append(infor_1)
        }
        
        SelectCity.delegate = self
        SelectCity.dataSource = self
    }
}
    
extension SelectCityController : UITableViewDelegate, UITableViewDataSource{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(cityInformation.count)
        return cityInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCityCell", for: indexPath) as? SelectCityTableviewCellTableViewCell else {
            fatalError("The dequeued cell is not an instance of SelectCityTableviewCellTableViewCell.")
        }
        
        cell.CityName.text = cityInformation[indexPath.row].cityName
        cell.CityImage.image = cityInformation[indexPath.row].cityImage
        
        cell.CityImage.layer.cornerRadius = 10
        cell.Background.layer.cornerRadius = 10
        
        return cell
    }
}

