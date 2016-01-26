//
//  Food.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/20.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import Foundation
import SwiftyJSON

class Food: NSObject {
    var id: Int
    var foodberId: Int
    var name: String
    var price: Int
    var imageUrl: String
    var orderCount: Int
    
    init(json: JSON){
        self.id = json["id"].intValue
        self.foodberId = json["food_truck_id"].intValue
        self.name = json["name"].stringValue
        self.price = json["price"].intValue
        self.imageUrl = json["picture_medium"].stringValue
        self.orderCount = json["count"].intValue
    }
}
