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
    
}

class RouteAttractionController: UIViewController {

    @IBAction func ReturnButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    @IBOutlet weak var CityName: UILabel!
    @IBOutlet weak var CollectionView: UICollectionView!
    var AttractionData : [AttractionInformation] = []
    var delgate : RouteAttractionControllerDelgate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CollectionView.delegate = self
        CollectionView.dataSource = self
    }
}

extension RouteAttractionController : UICollectionViewDelegate, UICollectionViewDataSource{
    
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
        
        cell.toggleSelected()
        
        return cell
    }
}
