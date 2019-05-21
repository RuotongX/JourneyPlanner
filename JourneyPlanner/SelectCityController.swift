//
//  SelectCityController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 20/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

class SelectCityController: UIViewController{

    @IBAction func ReturnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var SelectCity: UITableView!
    
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
        
        return cityInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCityCell", for: indexPath) as? SelectCityCell else {
            fatalError("The dequeued cell is not an instance of SelectCityTableviewCellTableViewCell.")
        }
        
        cell.cityName.text = cityInformation[indexPath.row].cityName
        cell.imagePath.image = cityInformation[indexPath.row].cityImage
        cell.DaysTIme.text = String(cityInformation[indexPath.row].cityStopTime)
       
        cell.imagePath.layer.cornerRadius = 20
        cell.background.layer.cornerRadius = 20
        
        //Define the empty function taht used to set tha action for the increase button - ZHE WANG
        cell.IncreaseButton = {
            self.cityInformation[indexPath.row].cityStopTime = self.cityInformation[indexPath.row].cityStopTime + 1
            cell.DaysTIme.text = String(self.cityInformation[indexPath.row].cityStopTime)
        }
        
        return cell
    }
}

