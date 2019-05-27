//
//  RouteListViewController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 13/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

protocol RouteListViewControllerDelegate {
    
}

class RouteListViewController: UIViewController {

    var delegate: RouteListViewControllerDelegate?
    @IBOutlet weak var TripTableView: UITableView!
    
    //access the routeInformation class to store the test data, and set it to global variable - ZHE WANG
    var routeInfo : [RouteInformation] = []
    
    //Return to home page
    @IBAction func ReturnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadData()
        
        //tableview 数据
        TripTableView.dataSource = self
        //tableview 的代理(操作)
        TripTableView.delegate = self

        // Do any additional setup after loading the view.
        
    }
    
    func LoadData(){
        
        //access those two class that used to store the section's data of route - ZHE WANG
        var citylist : [CityListInformation] = []
        var citylist2 : [CityListInformation] = []

        var attraction_Auckland : [AttractionInformation] = []
        var attraction_Dargville : [AttractionInformation] = []
        var attraction_Kaitaia : [AttractionInformation] = []
        
        if let RouteImage = UIImage(named: "Trip-Piha1x"){
            
            if let AttractionImage_1 = UIImage(named: "Trip-Piha1x"){
                attraction_Auckland.append(AttractionInformation.init(Name: "Piha Beach", Location: CLLocationCoordinate2D(latitude: 174.471, longitude: -36.954), attractionImage: AttractionImage_1))
            }
            
            if let AttractionImage_2 = UIImage(named: "Trip-SkyTower-90-1x"){
                attraction_Auckland.append(AttractionInformation.init(Name: "Auckland Skytower", Location: CLLocationCoordinate2D(latitude: 174.76, longitude: -36.85), attractionImage: AttractionImage_2))
            }
            
            if let AttractionImage_3 = UIImage(named: "Trip-Waiheke-Island"){
                attraction_Auckland.append(AttractionInformation.init(Name: "Waihike Island", Location: CLLocationCoordinate2D(latitude: 175.1, longitude: -16.8), attractionImage: AttractionImage_3))
            }
            
            if let CityImage = UIImage(named: "Trip-Skytower-150*110-1x"){
                citylist.append(CityListInformation.init(name: "Auckland", time: 3, location: CLLocationCoordinate2D(latitude: 174.7619066, longitude: -36.8484609), image : CityImage, attractions: attraction_Auckland))
            }
            
            routeInfo.append(RouteInformation.init(name: "Auckland Explore", time: 3, image : RouteImage, city: citylist))
        }
        
        if let RouteImage = UIImage(named: "Tripe-Cape_Reinga_1x"){
            
            if let AttractionImage_1 = UIImage(named: "Trip-Dargaville-Attraction-1"){
                attraction_Dargville.append(AttractionInformation.init(Name: "Kai Iwi Lakes", Location: CLLocationCoordinate2D(latitude: -35.8094, longitude: 173.6461 ), attractionImage: AttractionImage_1))
            }
            
            if let CityImage = UIImage(named: "City-dargaville"){
                citylist2.append(CityListInformation.init(name: "Dargaville", time: 1, location: CLLocationCoordinate2D(latitude: -36.8484609, longitude: 174.7619066), image : CityImage, attractions: attraction_Dargville))
            }
            
            if let AttractionImage_1 = UIImage(named: "City-kaitaia"){
                attraction_Kaitaia.append(AttractionInformation.init(Name: "Kai Iwi Lakes", Location: CLLocationCoordinate2D(latitude: -35.8094, longitude: 173.6461 ), attractionImage: AttractionImage_1))
            }
            
            if let CityImage = UIImage(named: "City-kaitaia"){
                citylist2.append(CityListInformation.init(name: "Kaitaia", time: 1, location: CLLocationCoordinate2D(latitude: -35.0782671, longitude: 173.3789389), image : CityImage, attractions: attraction_Kaitaia))
            }
            
            routeInfo.append(RouteInformation.init(name: "Twin Cost Discovery", time: 6, image : RouteImage, city: citylist2))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "RouteSegue"{
            if let selectCityController = segue.destination as? RouteSelectCityController{
                selectCityController.delgate = self
                
                if let cell = sender as? UITableViewCell{
                    if let indexPath = TripTableView.indexPath(for: cell),
                        let city = routeInfo[indexPath.row].Cities{
                            selectCityController.cityInformation = city
                    }
                }
            }
        }
    }
}

//inherence 3D touch preview delgate
extension RouteListViewController : UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate, RouteSelectCityControllerDelgate{
    
    //connect and set the preview page
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        //set the index used to get row number of user pressed
        guard let indexPath = TripTableView.indexPathForRow(at: location),
            let cell = TripTableView.cellForRow(at: indexPath)
            else{
                return nil
        }

        previewingContext.sourceRect = cell.frame

        let previewing = storyboard?.instantiateViewController(withIdentifier: "PreviewController") as! RoutePreviewController

        return previewing
    }

    //Pop actions
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {

        let destination  = storyboard?.instantiateViewController(withIdentifier: "SelectCityViewController")

        show(destination!, sender: self)
    }
    
    //返回cell的数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return routeInfo.count
    }
    
    //Reuseable - set reuseable function for the cell
    //Only need to create one cell, other row will reuse the first cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //设置RouteCell_1是一个可循环的table cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "routeOptionCell_1", for: indexPath)as? RouteSelectTableViewCell else{fatalError("The dequeued cell is not an instance of RouteSelectTableViewCell.") }

        cell.RouteName.text = routeInfo[indexPath.row].routeName
        cell.Auckland_Explore.image = routeInfo[indexPath.row].routeImage
        
        //check whether the device work for 3D touch
        if traitCollection.forceTouchCapability == .available{
            registerForPreviewing(with: self, sourceView: cell)
        }
        
        cell.Auckland_Explore.layer.cornerRadius = 10
        cell.BlackCover.layer.cornerRadius = 10
        
        return cell
    }
}
    
    

