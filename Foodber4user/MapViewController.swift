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
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var iconMe: UIImageView!

    let locationManager = CLLocationManager()
    var isFirstGetLocation = false
    var isAddAnnotations = false
    var regionCanChange = true
    
    var foodberArray = [Foodber]()
    var foodArray = [Food]()
    var myannotationArray = [MyAnnotation]()
    var userLocation = Location()
    
    var i = 0
    var foodberLoctaion = [
        [25.051501, 121.532838],
        [25.051201, 121.532838],
        [25.050874, 121.532838],
        [25.050484, 121.532838],
        [25.050061, 121.532838],
        [25.049619, 121.532838],
        [25.049290, 121.532838],
        [25.048888, 121.532838],
        [25.048433, 121.532838],
        [25.048038, 121.532838],
        [25.047658, 121.532838],
        [25.047258, 121.532838],
        [25.046982, 121.532838],
        [25.046532, 121.532838],
        [25.046120, 121.532838],
        [25.045671, 121.532838],
        [25.045249, 121.532838]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.tintColor = UIColor(red: 243/255.0, green: 168/255.0, blue: 34/255.0, alpha: 1)
 
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        addressTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "trigger", name: "letFoodberGo", object: nil)
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //MARK: -UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        geocodeAddressString(textField.text!)
//        textField.userInteractionEnabled = false
//        iconMe.hidden = true
        regionCanChange = false
        
        return true
    }
    func removeAnnotation(){
        self.mapView.removeAnnotation(mapView.annotations[0])
    }
    
    func makeAnnotation(latitude: Double, longitude: Double){
            self.mapView.addAnnotation(MyAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: "吃義燉飯", subtitle: ""))
    }
    
    
    
    func trigger(){
        let timer = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: "foodberRun:", userInfo: nil, repeats: true)
        
    }
    func foodberRun(timer: NSTimer){
        i++
        if i == 16{
            timer.invalidate()
        }
        self.mapView.removeAnnotation(self.mapView.annotations.last!)
        self.makeAnnotation(foodberLoctaion[i][0], longitude: foodberLoctaion[i][1])
    }
    

    
}

extension MapViewController: MKMapViewDelegate{
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if self.isFirstGetLocation == false{
            isFirstGetLocation = true
            let region = MKCoordinateRegion(center: userLocation.location!.coordinate, span: MKCoordinateSpanMake(0.018, 0.018))
            mapView.region = region
            mapView.showsUserLocation = false
            iconMe.hidden = false
            self.makeAnnotation(foodberLoctaion[0][0], longitude: foodberLoctaion[0][1])
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if regionCanChange {
            if isFirstGetLocation {
                let centerlocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
                reverseGeocodeLocation(centerlocation)
            }
        }
    }
    
    //MARK: -Geocoder
    
    func reverseGeocodeLocation(location: CLLocation){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation( location, completionHandler: { (places: [CLPlacemark]?, error: NSError?) -> Void in
            if places?.count > 0{
                let placeMark = places?.first
                let addressArray = placeMark?.addressDictionary?["FormattedAddressLines"] as! [String]
                for address in addressArray{
                    self.addressTextField.text! = address
                    self.userLocation.address = address
                }
            }
        })
    }
    
    
    func geocodeAddressString(address: String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (places: [CLPlacemark]?, error: NSError?) -> Void in
            if places?.count > 0{
                let placeMark = places?.first
                self.userLocation.latitude = placeMark!.location?.coordinate.latitude
                self.userLocation.longitude = placeMark!.location?.coordinate.longitude
                let viewCenterLocation = placeMark!.location
                self.mapView.region = MKCoordinateRegion(center: viewCenterLocation!.coordinate, span: MKCoordinateSpanMake(0.018, 0.018))
            }
        }
    }
   
    //MARK: -Annotation
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        if annotation is MyAnnotation{
            annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
            if annotationView == nil{
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                annotationView?.image = UIImage(named: "mapUseOfFoodber")
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
        }
        return annotationView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MenuTableViewController") as! MenuTableViewController
//        controller.foodberArray = foodberArray
//        controller.foodberName = title!
        controller.userLocation = userLocation
        mapView.deselectAnnotation(annotation, animated: false)
        self.navigationController?.pushViewController(controller,animated: true)
    }
    
    
}
