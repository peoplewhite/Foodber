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

class MapViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var iconMe: UIImageView!

    let locationManager = CLLocationManager()
    var isFirstGetLocation = false
    
    let foodber = Annotation(coordinate: CLLocationCoordinate2D(latitude: 25.0336, longitude: 121.565), title: "1", subtitle: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("FBSDKAccessToken.currentAccessToken() \(FBSDKAccessToken.currentAccessToken())")
        if FBSDKAccessToken.currentAccessToken() == nil{
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("FacebookViewController")
            self.navigationController?.presentViewController(controller!, animated: false, completion: nil)
        }
        
        self.tabBarController?.tabBar.tintColor = UIColor(red: 243/255.0, green: 168/255.0, blue: 34/255.0, alpha: 1)
        self.navigationController?.navigationBarHidden = true
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        addressTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //MARK: -UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        geocodeAddressString(textField.text!)
        return true
    }
}

extension MapViewController: MKMapViewDelegate{
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if self.isFirstGetLocation == false{
            isFirstGetLocation = true
            let region = MKCoordinateRegion(center: userLocation.location!.coordinate, span: MKCoordinateSpanMake(0.005, 0.005))
            mapView.region = region
            mapView.showsUserLocation = false
            self.mapView.addAnnotation(self.foodber)
            iconMe.hidden = false
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

        if isFirstGetLocation {
            let centerlocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            reverseGeocodeLocation(centerlocation)

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
                }
            }
        })
    }
    
    
    func geocodeAddressString(address: String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (places: [CLPlacemark]?, error: NSError?) -> Void in
            if places?.count > 0{
                let placeMark = places?.first
                let viewCenterLocation = placeMark!.location
                self.mapView.region = MKCoordinateRegion(center: viewCenterLocation!.coordinate, span: MKCoordinateSpanMake(0.005, 0.005))
            }
        }
    }
   
    //MARK: -Annotation
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        if annotation is Annotation{
            annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
            if annotationView == nil{
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                annotationView?.image = UIImage(named: "mapUseOfFoodber")
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .InfoDark)
            }
        }
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation
        let title = (annotation?.title)!
        var foodbertitleDictionary = [String: String]()
        foodbertitleDictionary = ["title": title!]
        NSNotificationCenter.defaultCenter().postNotificationName("updateFoodberTitle", object: nil, userInfo: foodbertitleDictionary)
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        self.navigationController?.pushViewController(controller,animated: true)
        
    }
    
    
}
