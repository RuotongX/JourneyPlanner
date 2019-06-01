//
//  RouteAttractionCell.swift
//  JourneyPlanner
//
//  Created by ZHE WANG on 27/05/19.
//  Copyright © 2019 RuotongX. All rights reserved.
//

import UIKit

class RouteAttractionCell: UICollectionViewCell {
    
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
