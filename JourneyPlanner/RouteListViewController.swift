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
    var StopTimeA : Int!
    var StopTimeB : Int!

    var RowAtPreview : Int?
    
    //access the routeInformation class to store the test data, and set it to global variable - ZHE WANG
    var routeInfo : [RouteInformation] = []
    
    //Return to home page
    @IBAction func ReturnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromPlist()
        
        //tableview 数据
        TripTableView.dataSource = self
        //tableview 的代理(操作)
        TripTableView.delegate = self

        // Do any additional setup after loading the view.
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func loadDataFromPlist(){
        
        let plistPath = Bundle.main.path(forResource: "RouteInformation", ofType: "plist")!
        let routes = NSArray(contentsOfFile: plistPath)!
        
        routeInfo = []
        
        for singleRoute in routes{
            
            let rt = singleRoute as! NSDictionary
            
            let routeName = rt["RouteName"] as! String
            let routeStopTime = rt["RouteStopTime"] as! Int
            let routeImageName = rt["RouteImageName"] as! String
            
            var cities : [String] = []
            let cityList = rt["CityList"] as! NSArray
            
            for city in cityList{
                let cityName = city as! String
                cities.append(cityName)
            }
            
            if routeStopTime > StopTimeA && routeStopTime <= StopTimeB{
                if let image = UIImage(named: routeImageName){
                    let newRT = RouteInformation(name: routeName, time: routeStopTime, image: image)
                    newRT.CitieName = cities
                    self.routeInfo.append(newRT)
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "RouteSegue"{
            if let selectCityController = segue.destination as? RouteSelectCityController{
                selectCityController.delgate = self
                
                if let cell = sender as? UITableViewCell{
                    if let indexPath = TripTableView.indexPath(for: cell){
                        selectCityController.routeName = routeInfo[indexPath.row].routeName
                        selectCityController.SelectedCityList = routeInfo[indexPath.row].CitieName
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

        guard let cell = previewingContext.sourceView as? UITableViewCell else{
            return UIViewController()
        }
        
        let indexPath = TripTableView.indexPath(for: cell)

        previewingContext.sourceRect = cell.frame
    
        self.RowAtPreview = indexPath?.row
    
        let previewing = storyboard?.instantiateViewController(withIdentifier: "PreviewController") as! RoutePreviewController
        
        previewing.routeName = routeInfo[RowAtPreview!].routeName
        previewing.cityName = routeInfo[RowAtPreview!].CitieName
    
        return previewing
    }

    //Pop actions
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController){

        let destination  = storyboard?.instantiateViewController(withIdentifier: "SelectCityViewController") as? RouteSelectCityController
        
        destination?.routeName = routeInfo[RowAtPreview!].routeName
        destination?.SelectedCityList = routeInfo[RowAtPreview!].CitieName
        
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
    
    

