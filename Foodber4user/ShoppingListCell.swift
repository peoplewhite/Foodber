//
//  ShoppingListCell.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/19.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit

class ShoppingListCell: UITableViewCell {

    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var orderCount: UILabel!
    @IBOutlet weak var viewOfCell: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        viewOfCell.backgroundColor = UIColor.whiteColor()
        viewOfCell.layer.borderWidth = 0.1
        viewOfCell.layer.borderColor = UIColor.blackColor().CGColor
        foodName.layer.cornerRadius = 5

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
