//
//  SelectCirtyController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 24/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

class SelectCirtyController: UIViewController {
    
    
    @IBAction func ReturnButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    var cityInformation : [CityListInformation] = []
    
    @IBOutlet weak var SelectCityTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = UIImage(named: "Trip-Skytower-150*110-1x"){
            let location = CLLocationCoordinate2D(latitude: 174.7619066, longitude: -36.8484609)
            let infor_1 = CityListInformation(name: "Auckland", time: 1, location: location, image: image)
            
            cityInformation.append(infor_1)
        }
        
        SelectCityTableview.dataSource = self
        SelectCityTableview.delegate = self
    }
}

extension SelectCirtyController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCityCell", for: indexPath) as? SelectCityCell else {
            fatalError("The dequeued cell is not an instance of SelectCityTableviewCellTableViewCell.")
        }
        
        cell.CityNmae.text = cityInformation[indexPath.row].cityName
        
        cell.CityImage.image = cityInformation[indexPath.row].cityImage
        
        cell.TimeLabel.text = String(cityInformation[indexPath.row].cityStopTime)
        
        cell.CityImage.layer.cornerRadius = 20
        cell.Background.layer.cornerRadius = 20
        
        //Define the empty function taht used to set tha action for the increase button - ZHE WANG
        cell.IncreaseButton = {
            
            let impactFeedBackGenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedBackGenerator.prepare()
            impactFeedBackGenerator.impactOccurred()
            
            self.cityInformation[indexPath.row].cityStopTime = self.cityInformation[indexPath.row].cityStopTime + 1
            cell.TimeLabel.text = String(self.cityInformation[indexPath.row].cityStopTime)
            
        }
        
        cell.DecreaseButton = {
            
            if self.cityInformation[indexPath.row].cityStopTime > 1{
                let impactFeedBackGenerator = UIImpactFeedbackGenerator(style: .light)
                impactFeedBackGenerator.prepare()
                impactFeedBackGenerator.impactOccurred()
                
                self.cityInformation[indexPath.row].cityStopTime = self.cityInformation[indexPath.row].cityStopTime - 1
                cell.TimeLabel.text = String(self.cityInformation[indexPath.row].cityStopTime)
            } else{
                let error = UINotificationFeedbackGenerator()
                error.notificationOccurred(.error)
            }
        }
        
        return cell
    }
}
