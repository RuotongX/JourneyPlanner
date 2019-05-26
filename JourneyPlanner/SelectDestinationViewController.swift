//
//  SelectDestinationViewController.swift
//  JourneyPlanner
//
//  Created by Dalton Chen on 26/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

protocol SelectDestinationViewControllerDelegate {
    func didSelectNewDestination(_ controller: SelectDestinationViewController, selectedCity : CityListInformation)
}

class SelectDestinationViewController: UIViewController {
    
    var delegate:SelectDestinationViewControllerDelegate?
    var availableCities : [CityListInformation] = []
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCityInformation()

        tableview.delegate = self
        tableview.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    

    
    private func loadCityInformation(){
        
        if let aucklandImage = UIImage(named: "City-auckland"){
            let auckland = CityListInformation(name: "Auckland", time: 0, location: CLLocationCoordinate2D(latitude: -36.8484609, longitude:174.7619066 ), image: aucklandImage)
            availableCities.append(auckland)
        }
        if let wellingtonImange = UIImage(named: "City-wellington"){
            let wellington = CityListInformation(name: "Wellington", time: 0, location: CLLocationCoordinate2D(latitude:  -41.28666552 , longitude: 174.772996908), image: wellingtonImange)
            availableCities.append(wellington)
        }
        if let whangareiImange = UIImage(named: "City-whangarei"){
            let whangarei = CityListInformation(name: "Whangarei", time: 0, location: CLLocationCoordinate2D(latitude: -35.73167, longitude:  174.32391), image: whangareiImange)
            availableCities.append(whangarei)
        }
        if let paihiaImange = UIImage(named: "City-paihia"){
            let paihia = CityListInformation(name: "Paihia", time: 0, location: CLLocationCoordinate2D(latitude: -35.2833322, longitude:  174.083333), image: paihiaImange)
            availableCities.append(paihia)
        }
        if let kaitaiaImange = UIImage(named: "City-kaitaia"){
            let kaitaia = CityListInformation(name: "Kaitaia", time: 0, location: CLLocationCoordinate2D(latitude: -35.1125, longitude: 173.262778), image: kaitaiaImange)
            availableCities.append(kaitaia)
        }
        if let dargavilleImange = UIImage(named: "City-dargaville"){
            let dargaville = CityListInformation(name: "Dargaville", time: 0, location: CLLocationCoordinate2D(latitude: -35.93333, longitude:  173.88333), image: dargavilleImange)
            availableCities.append(dargaville)
        }
        
        if let hamiltonImange = UIImage(named: "City-hamilton"){
            let hamilton = CityListInformation(name: "Hamilton", time: 0, location: CLLocationCoordinate2D(latitude: -37.783333, longitude: 175.2833), image: hamiltonImange)
            availableCities.append(hamilton)
        }
        
        if let taurangaImange = UIImage(named: "City-tauranga"){
            let tauranga = CityListInformation(name: "Tauranga", time: 0, location: CLLocationCoordinate2D(latitude: -37.68611, longitude: 176.16667), image: taurangaImange)
            availableCities.append(tauranga)
        }
        
        if let gisborneImange = UIImage(named: "City-gisborne"){
            let gisborne = CityListInformation(name: "Gisborne", time: 0, location: CLLocationCoordinate2D(latitude: -38.65333 , longitude: 178.00417), image: gisborneImange)
            availableCities.append(gisborne)
        }
        
        if let taupoImange = UIImage(named: "City-taupo"){
            let taupo = CityListInformation(name: "Taupo", time: 0, location: CLLocationCoordinate2D(latitude: -38.68333 , longitude: 176.08333), image: taupoImange)
            availableCities.append(taupo)
        }
        if let napierImange = UIImage(named: "City-napier"){
            let napier = CityListInformation(name: "Napier", time: 0, location: CLLocationCoordinate2D(latitude: -39.48333, longitude: 176.91667), image: napierImange)
            availableCities.append(napier)
        }
        
        if let palmerstonImage = UIImage(named: "City-palmerston"){
            let palmerston = CityListInformation(name: "Palmerston North", time: 0, location: CLLocationCoordinate2D(latitude: -40.35636 , longitude: 175.61113), image: palmerstonImage)
            availableCities.append(palmerston)
        }
    }
    
    @IBAction func ReturnButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SelectDestinationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "destination_city", for: indexPath) as? SelectDestinationTableViewCell else {fatalError("The dequeued cell is not an instance of SelectDestinationTableViewCell.")}
        
        cell.cityImage.image = availableCities[indexPath.row].cityImage
        cell.cityImage.layer.cornerRadius = 8
        cell.CityImangeDarkCover.layer.cornerRadius = 8
        cell.CityName.text = availableCities[indexPath.row].cityName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cityInfo = availableCities[indexPath.row]
        
        let alert = UIAlertController(title: "Day", message: "How long would you like to stay at \(cityInfo.cityName)?", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Stay Length"
            textfield.keyboardType = .numberPad
        }
        let confirm = UIAlertAction(title: "OK", style: .default) { (action) in
            
            if let textfields = alert.textFields{
                if let textfield = textfields.first{
                    if let text = textfield.text{
                        if text.isEmpty == false {
                            cityInfo.cityStopTime = Int(text) ?? 0
                        }
                    }
                }
            }
            
            if let delegate = self.delegate{
                delegate.didSelectNewDestination(self, selectedCity: cityInfo)
                self.dismiss(animated: true, completion: nil)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert,animated: true)
    }
    
    
}
