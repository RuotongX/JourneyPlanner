//
//  RouteAttractionController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 27/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

//Protocol which using to transfer the data for his superior class - ZHE WANG
protocol RouteAttractionControllerDelgate {
    
    //Set the return data
    func didSelectAttractionFromList(_ controller: RouteAttractionController, SelectedAttraction : [AttractionInformation], indexNumber : Int)
    
}

//UIViewController which used to manage UI interface for select route page
//Contain the load data method, user selected method - ZHE WANG
class RouteAttractionController: UIViewController {
    
    //Set the action of return button, and retyrb the data to select city controller
    @IBAction func ReturnButton(_ sender: UIButton) {
        dismiss(animated: true) {
            if let delegate = self.delegate,
                let indexNumber = self.cityIndexNumber{
                delegate.didSelectAttractionFromList(self, SelectedAttraction: self.SelectedData, indexNumber: indexNumber)
            }
        }
    }
    
    //Set the color of loading bar which at the top of screen
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    //Necessary materials for the Select Route
    @IBOutlet weak var CityName: UILabel!
    @IBOutlet weak var CollectionView: UICollectionView!
    var AttractionData : [AttractionInformation] = []
    var SelectedData : [AttractionInformation] = []
    var cityIndexNumber : Int?
    var cityName : String?
    
    //Delgate that used to connect the protocol from Select City Controller - ZHE WANG
    var delegate : RouteAttractionControllerDelgate?
    
    // when user open the software, this viewdidload will be automatically called
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tickData()

        CollectionView.delegate = self
        CollectionView.dataSource = self
        
        if let cityname = self.cityName{
            self.CityName.text = cityname
        }
    }
    
    //Compare whether user click the attraction card
    private func tickData(){
        
        for newAtt in AttractionData{
            for selectedAtt in SelectedData{
                if newAtt.attractionName == selectedAtt.attractionName{
                    newAtt.isSelectedFromPage = true
                }
            }
        }
    }
    
    //Load data method, that will connect and receive the data from Properity List - ZHE WANG
    private func loadData(){
        if let CityName = self.cityName{
            AttractionData = []
            
            // load from bundle (left hand side)
            let path = Bundle.main.path(forResource: "AttractionList", ofType: "plist")!
            let cityArray = NSArray(contentsOfFile: path)!
            
            //Choice which data need to load
            for city in cityArray{
                let cityDict = city as! NSDictionary
                
                let attractionCityName = cityDict["cityName"] as! String
                
                if attractionCityName == CityName{
                    let attractionArray = cityDict["Attraction"] as! NSArray
                    
                    for attraction in attractionArray{
                        
                        let attractionDict = attraction as! NSDictionary
                        let attractionName = attractionDict["AttractionName"] as! String
                        let attractionIMGname = attractionDict["AttractionImageName"] as! String
                        let attractionLocationLon = attractionDict["AttractionLocation_Lon"] as! Double
                        let attractionLocationLat = attractionDict["AttractionLocation_Lat"] as! Double
                        
                        //Write the data to our data constructor that can easy transfer to the superio class by protocol - ZHE WANG
                        //Also include the analyzing conditions that determine wheather the data compare to the user selected. - ZHE WANG
                        if let attImage = UIImage(named: attractionIMGname){
                            let newAtt = AttractionInformation(Name: attractionName, Location: CLLocationCoordinate2D(latitude: attractionLocationLat, longitude: attractionLocationLon), attractionImage: attImage)
                            newAtt.attractionImageName = attractionIMGname
                            AttractionData.append(newAtt)
                        }
                    }
                }
            }
        }
    }
}

//inherence UITableview delgate and data source
//Inclues the paramters setting on UI page - ZHE WANG
extension RouteAttractionController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    //Return the data that user select and rechange the parameters of select label
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        AttractionData[indexPath.row].isSelectedFromPage = !AttractionData[indexPath.row].isSelectedFromPage
        
        collectionView.reloadData()
        
        SelectedData = []
        for attraction in self.AttractionData{
            if attraction.isSelectedFromPage {
                SelectedData.append(attraction)
            }
        }
    }
    
    //Return the number of cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return AttractionData.count
    }
    
    //Reuseable - set reuseable function for the cell
    //Only need to create one cell, other row will reuse the first cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? RouteAttractionCell else{
            fatalError("The dequeued cell is not an instance of RouteAttractionCell.")
        }
        
        //Set the content paramters for the items on select city page
        cell.AttractionName.text = AttractionData[indexPath.row].attractionName
        cell.AttractionImage.image = AttractionData[indexPath.row].attractionImage
        
        //Set the laybout paramters for the items on select city page.
        cell.CellBackground.layer.cornerRadius = 10
        cell.AttractionImage.layer.cornerRadius = 10
        
        cell.updateCheckMark(selected: AttractionData[indexPath.row].isSelectedFromPage)
        
        return cell
    }
}
