//
//  Foodber.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/15.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import Foundation
import SwiftyJSON

class Foodber: NSObject {
    var id: Int
    var name: String
    var longitude: Double
    var latitude: Double
    var imageUrl: String
    var food: [Food]
    
    
    init(json: JSON){
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.longitude = json["longitude"].doubleValue
        self.latitude = json["latitude"].doubleValue
        self.imageUrl = json["picture_medium"].stringValue
        self.food = [Food]()
        let foodArray = json["foods"].array
        if let foodArray = foodArray{
            for food in foodArray{
                self.food.append(Food(json: food))
            }
        }
    }
    
    
}
