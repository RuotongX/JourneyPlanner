//
//  RouteListViewController.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 13/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

protocol RouteListViewControllerDelegate {
    
}

class RouteListViewController: UIViewController {

    var delegate: RouteListViewControllerDelegate?
    @IBOutlet weak var TripTableView: UITableView!
    var routeInfo : [RouteInformation] = []
    
    //Return to home page
    @IBAction func ReturnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test data
        if let image = UIImage(named: "Trip-Piha1x"){
            let infor_1 = RouteInformation(name: "Auckland Explore", time: 3, image: image)
        
            routeInfo.append(infor_1)
        }
        
        if let image2 = UIImage(named: "Tripe-Cape_Reinga_1x"){
            let infor_2 = RouteInformation(name: "Twin Coast Discovery", time: 7, image: image2)
            
            routeInfo.append(infor_2)
        }

        //tableview 数据
        TripTableView.dataSource = self
        //tableview 的代理(操作)
        TripTableView.delegate = self

        // Do any additional setup after loading the view.
    }
}

//inherence 3D touch preview delgate
extension RouteListViewController : UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate{
    
    //connect and set the preview page
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
     
        //set the index used to get row number of user pressed
        let index = TripTableView.indexPathForRow(at: location)
        guard let indexPath = index,
            let cell = TripTableView.cellForRow(at: indexPath)
            else{
                return nil
        }
        
        previewingContext.sourceRect = cell.frame
        
        let previewing = storyboard?.instantiateViewController(withIdentifier: "PreviewController") as! RoutePreviewController
        
        UserDefaults().setValue(index?.row
            , forKey: "CompareRoute")

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
    
    

