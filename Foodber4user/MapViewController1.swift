//
//  MapViewController.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/15.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController1: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var isFirstGetLocation = false
    
    var foodberArray = [Foodber]()
//    let foodber1 = Foodber(name: "James", longitude: 25.0336, latitude: 121.565)
//    let foodber2 = Foodber(name: "Ellis", longitude: 25.0325, latitude: 121.555)
    let foodber = Annotation(coordinate: CLLocationCoordinate2D(latitude: 25.0336, longitude: 121.565), title: "1", subtitle: "")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.tintColor = UIColor(red: 243/255.0, green: 168/255.0, blue: 34/255.0, alpha: 1)
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
//        foodberArray.append(foodber1)
//        foodberArray.append(foodber2)
//        for var i = 0; i < foodberArray.count; i++ {
//        self.mapView.addAnnotation(Annotation(coordinate: CLLocationCoordinate2D(latitude: foodberArray[i].latitude!, longitude: foodberArray[i].longitude!), title: foodberArray[i].name!, subtitle: ""))
//        }
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if self.isFirstGetLocation == false{
            isFirstGetLocation = true
            let region = MKCoordinateRegion(center: userLocation.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
//            mapView.centerCoordinate = userLocation.location!.coordinate
            mapView.region = region
            mapView.showsUserLocation = true
            self.mapView.addAnnotation(foodber)
            
            self.geoCoder.reverseGeocodeLocation(userLocation.location!, completionHandler: { (places: [CLPlacemark]?, err: NSError?) -> Void in
                if places?.count > 0{
                    let myLocation = places?.first
                    let addressArray = myLocation?.addressDictionary?["FormattedAddressLines"] as! [String]
                    for address in addressArray{
                        print("\(address)")
                    }
                }
            })
            
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        if annotation is Annotation{
            annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("foodber")
            if annotationView == nil{
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "foodber")
                annotationView?.image = UIImage(named: "mapUse")
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .InfoDark)
            }
        }
        return annotationView
    }
    
}
