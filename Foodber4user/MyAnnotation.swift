//
//  MyAnnotation.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/22.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
