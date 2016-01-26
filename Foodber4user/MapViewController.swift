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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromServer()
        
        print("FBSDKAccessToken.currentAccessToken() \(FBSDKAccessToken.currentAccessToken())")
                
        self.tabBarController?.tabBar.tintColor = UIColor(red: 243/255.0, green: 168/255.0, blue: 34/255.0, alpha: 1)
 
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        addressTextField.delegate = self
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
        textField.userInteractionEnabled = false
        iconMe.hidden = true
        regionCanChange = false
        
        return true
    }
    
    func getDataFromServer(){
        let apiUrl = "https://gentle-wave-2437.herokuapp.com/api/v1/food_trucks.json"
        Alamofire.request(.GET, apiUrl ).responseJSON{ response in
            if let data = response.result.value{
            let result = JSON(data)["data"]
                for(_, subJson):(String, JSON) in result{
                    let foodber = Foodber(json: subJson)
                    self.foodberArray.append(foodber)
                    }
                }
                if self.isFirstGetLocation == true && self.isAddAnnotations == false {
                    self.makeAnnotaion(self.foodberArray)

                }

            }
    }
    
    func makeAnnotaion(foodberArray: [Foodber]){
        for var i = 0; i < foodberArray.count; i++ {
            let foodber = foodberArray[i]
            self.mapView.addAnnotation(MyAnnotation(coordinate: CLLocationCoordinate2D(latitude: foodber.latitude, longitude: foodber.longitude), title: foodber.name, subtitle: ""))
        }
    }
}

extension MapViewController: MKMapViewDelegate{
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print("didUpdateUserLocation1")
        if self.isFirstGetLocation == false{
            print("didUpdateUserLocation2")
            isFirstGetLocation = true
            let region = MKCoordinateRegion(center: userLocation.location!.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
            mapView.region = region
           
            mapView.showsUserLocation = false
            iconMe.hidden = false
            
            if self.foodberArray.isEmpty == false {
                self.isAddAnnotations = true
                self.makeAnnotaion(self.foodberArray)
            }
         

            
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
                self.mapView.region = MKCoordinateRegion(center: viewCenterLocation!.coordinate, span: MKCoordinateSpanMake(0.005, 0.005))
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
        let title = (annotation?.title)!
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MenuTableViewController") as! MenuTableViewController
        controller.foodberArray = foodberArray
        controller.foodberName = title!
        controller.userLocation = userLocation
        self.navigationController?.pushViewController(controller,animated: true)
    }
    
    
}
