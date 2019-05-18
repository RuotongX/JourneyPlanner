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
            let infor_1 = RouteInformation(routeImage: image, routeName: "Auckland Explore", routeStayPoints: ["Waiheke Island", "Auckland city", "Piha"])
        
            routeInfo.append(infor_1)
        }
        
        if let image2 = UIImage(named: "Tripe-Cape_Reinga_1x"){
            let infor_2 = RouteInformation(routeImage: image2, routeName: "Twin Coast Discovery", routeStayPoints: ["Auckland", "Dargaville", "Hokianga", "Kaitaia", "Doubtless Bay", "Paihia", "Whangarei"])
            
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
     
//        if let cell = previewingContext.sourceView as? UITableViewCell{
//
//        }
//
//        let indexPath = TripTableView.indexPath(for: cell)
        
        
        let previewing = storyboard?.instantiateViewController(withIdentifier: "RoutePreviewing")
        
        return previewing
    }
    
    //connect to the destination of preview page
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        let destination  = storyboard?.instantiateViewController(withIdentifier: "EditRoutePlanPage")
        
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
    
    

