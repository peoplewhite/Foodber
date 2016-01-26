//
//  MenuCell.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/8.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var rectView: UIView!
    @IBOutlet weak var foodView: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var counts: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    var countNumber = 0
    
    override func awakeFromNib() {
//        self.priceView.layer.borderColor = UIColor.blackColor().CGColor
//        self.priceView.layer.borderWidth = 0.5
        self.rectView.layer.borderColor = UIColor.grayColor().CGColor
        self.rectView.layer.borderWidth = 0.5
        self.foodView.layer.borderColor = UIColor.grayColor().CGColor
        self.foodView.layer.borderWidth = 0.5
        
    }    
}
