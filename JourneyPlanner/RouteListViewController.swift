//
//  RouteListViewController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 13/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

//Protocol which using to transfer the data for his superior class - ZHE WANG
protocol RouteListViewControllerDelegate {
    
}

//UIViewController which used to manage UI interface for select route page
//Contain the load data method, 3D touch jump bridge, user selected method - ZHE WANG
class RouteListViewController: UIViewController {

    //Delgate that used to connect the protocol from SelectCity Controller - ZHE WANG
    var delegate: RouteListViewControllerDelegate?
    
    //Necessary materials for the Select Route
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
    
    // when user open the software, this viewdidload will be automatically called
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromPlist()
        
        //tableview 数据
        TripTableView.dataSource = self
        //tableview 的代理(操作)
        TripTableView.delegate = self

        // Do any additional setup after loading the view.
        
    }
    
    //Set the color of loading bar which at the top of screen
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //Load data method, that will connect and receive the data from Properity List - ZHE WANG
    func loadDataFromPlist(){
        
        //Connect bridge for Properity List
        let plistPath = Bundle.main.path(forResource: "RouteInformation", ofType: "plist")!
        let routes = NSArray(contentsOfFile: plistPath)!
        
        routeInfo = []
        
        //Choice which data need to load
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
            
            //Write the data to our data constructor that can easy transfer to the sub class by protocol - ZHE WANG
            //Also include the analyzing conditions that determine wheather the data compare to the user selected. - ZHE WANG
            if routeStopTime > StopTimeA && routeStopTime <= StopTimeB{
                if let image = UIImage(named: routeImageName){
                    let newRT = RouteInformation(name: routeName, time: routeStopTime, image: image)
                    newRT.CitieName = cities
                    self.routeInfo.append(newRT)
                }
            }
        }
    }
    
    //Connect to the correspond segue that transfer the data by protocol - ZHE WANG
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        //Compare the correspond segue
        if segue.identifier == "RouteSegue"{
            
            //Compare the segue desentation
            if let selectCityController = segue.destination as? RouteSelectCityController{
                selectCityController.delgate = self
                
                //Access the delgate and set the correspond data
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

//inherence 3D touch preview delgate, UITableview delgate and data source
//Inclues the paramters setting on UI page, connect the peak and pop controller for 3D touch API - ZHE WANG
extension RouteListViewController : UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate, RouteSelectCityControllerDelgate{
    
    //connect and set the preview page (Peak function)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        //get the number of cell that user touched
        guard let cell = previewingContext.sourceView as? UITableViewCell else{
            return UIViewController()
        }
        
        //Set the gloable variabel RowAtPreview to the indexPaht that user touched, which used to determine which route data should be pass to next controller - ZHE WANG
        let indexPath = TripTableView.indexPath(for: cell)

        previewingContext.sourceRect = cell.frame
    
        self.RowAtPreview = indexPath?.row
    
        //Find and compare peak controller by using storyboard mehtod - ZHE WANG
        let previewing = storyboard?.instantiateViewController(withIdentifier: "PreviewController") as! RoutePreviewController
        
        previewing.routeName = routeInfo[RowAtPreview!].routeName
        previewing.cityName = routeInfo[RowAtPreview!].CitieName
    
        return previewing
    }

    //Pop actions, which connect to the desentaiton of preview page
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController){

        let destination  = storyboard?.instantiateViewController(withIdentifier: "SelectCityViewController") as? RouteSelectCityController
        
        destination?.routeName = routeInfo[RowAtPreview!].routeName
        destination?.SelectedCityList = routeInfo[RowAtPreview!].CitieName
        
        show(destination!, sender: self)
    }
    
    //Return the number of cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return routeInfo.count
    }
    
    //Reuseable - set reuseable function for the cell
    //Only need to create one cell, other row will reuse the first cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Set the cell to be a reuseable cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "routeOptionCell_1", for: indexPath)as? RouteSelectTableViewCell else{fatalError("The dequeued cell is not an instance of RouteSelectTableViewCell.") }

        cell.RouteName.text = routeInfo[indexPath.row].routeName
        cell.Auckland_Explore.image = routeInfo[indexPath.row].routeImage
        
        //check whether the device work for 3D touch
        if traitCollection.forceTouchCapability == .available{
            registerForPreviewing(with: self, sourceView: cell)
        }
        
        //Set the laybout paramters for the items on select city page.
        cell.Auckland_Explore.layer.cornerRadius = 10
        cell.BlackCover.layer.cornerRadius = 10
        
        return cell
    }
}
    
    

