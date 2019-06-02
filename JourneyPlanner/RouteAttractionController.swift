//
//  RouteAttractionController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 27/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit
import CoreLocation

protocol RouteAttractionControllerDelgate {
    
    func didSelectAttractionFromList(_ controller: RouteAttractionController, SelectedAttraction : [AttractionInformation], indexNumber : Int)
    
}

class RouteAttractionController: UIViewController {

    @IBAction func ReturnButton(_ sender: UIButton) {
        dismiss(animated: true) {
            if let delegate = self.delegate,
                let indexNumber = self.cityIndexNumber{
                delegate.didSelectAttractionFromList(self, SelectedAttraction: self.SelectedData, indexNumber: indexNumber)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    @IBOutlet weak var CityName: UILabel!
    @IBOutlet weak var CollectionView: UICollectionView!
    var AttractionData : [AttractionInformation] = []
    var SelectedData : [AttractionInformation] = []
    var cityIndexNumber : Int?
    var cityName : String?
    var delegate : RouteAttractionControllerDelgate?
    
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
    
    private func tickData(){
        
        for newAtt in AttractionData{
            for selectedAtt in SelectedData{
                if newAtt.attractionName == selectedAtt.attractionName{
                    newAtt.isSelectedFromPage = true
                }
            }
        }
    }
    
    
    private func loadData(){
        if let CityName = self.cityName{
            AttractionData = []
            
            let path = Bundle.main.path(forResource: "AttractionList", ofType: "plist")!
            let cityArray = NSArray(contentsOfFile: path)!
            
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

extension RouteAttractionController : UICollectionViewDelegate, UICollectionViewDataSource{
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return AttractionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? RouteAttractionCell else{
            fatalError("The dequeued cell is not an instance of RouteAttractionCell.")
        }
        
        cell.AttractionName.text = AttractionData[indexPath.row].attractionName
        cell.AttractionImage.image = AttractionData[indexPath.row].attractionImage
        
        cell.CellBackground.layer.cornerRadius = 10
        cell.AttractionImage.layer.cornerRadius = 10
        
        cell.updateCheckMark(selected: AttractionData[indexPath.row].isSelectedFromPage)
        
        return cell
    }
    
    
}
