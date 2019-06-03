//
//  RouteAttractionCell.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 27/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

//Cell controller which to set up the edit for the cells - ZHE WANG
class RouteAttractionCell: UICollectionViewCell {
    
    
    // this class is used to define the plan attraction collection view cell, it contains some necessary information for a cell - ZHE WANG
    @IBOutlet weak var AttractionImage: UIImageView!
    @IBOutlet weak var AttractionName: UILabel!
    @IBOutlet weak var CellBackground: UIImageView!
    @IBOutlet weak var CheckMark: UIImageView!
    
    func updateCheckMark (selected : Bool)
    {
        //If image is selected.
        if (selected)
        {
            //Show check mark image.
            self.CheckMark.image = UIImage(named: "Check-mark -Unselected")
            self.CheckMark.isHidden = false
        }
            
        else
        {
            //Hide check mark image.
//            self.CheckMark.image = UIImage(named: "Check-mark -Unselected")
            self.CheckMark.isHidden = true

        }
    }
}
