//
//  SelectCityTableviewCellTableViewCell.swift
//  
//
//  Created by ZHE WANG on 20/05/19.
//

import UIKit

class SelectCityTableviewCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var CityImage: UIImageView!
    @IBOutlet weak var CityName: UILabel!
    @IBOutlet weak var Background: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)

        // Configure the view for the selected state
    }

}
