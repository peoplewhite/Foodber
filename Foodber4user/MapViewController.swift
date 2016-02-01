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
    var trigger2Timer:NSTimer!
    
    var moveAnnotation:MyAnnotation!

    let locationManager = CLLocationManager()
    var isFirstGetLocation = false
    var isAddAnnotations = false
    var regionCanChange = true
    
    var foodberArray = [Foodber]()
    var foodArray = [Food]()
    var myannotationArray = [MyAnnotation]()
    var userLocation = Location()
    
    var foodber1Go = false
    
    var i = 0
    var j = 0
    
    var foodberLoctaion1 = [
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
    
    var foodberLoctaion2 = [
        [25.042269, 121.523243],
        [25.042235, 121.523356],
        [25.042141, 121.523584],
        [25.042055, 121.524150],
        [25.041916, 121.524348],
        [25.041535, 121.524241],
        [25.041368, 121.524295],
        [25.041235, 121.524146],
        [25.041070, 121.524081],
        [25.040808, 121.524038],
        [25.040531, 121.523931],
        [25.040366, 121.523883],
        [25.040055, 121.523801],
        [25.039818, 121.523730],
        [25.039582, 121.523681],
        [25.039386, 121.523620],
        [25.039134, 121.523559],
        [25.038714, 121.523451],
        [25.038326, 121.523317],
        [25.038115, 121.523268],
        [25.037899, 121.523204],
        [25.037611, 121.523120],
        [25.037446, 121.523069],
        [25.037213, 121.522999],
        [25.036904, 121.522914],
        [25.036583, 121.522816],
        [25.036263, 121.522930],
        [25.036141, 121.523246],
        [25.035964, 121.523606],
        [25.035839, 121.523904],
        [25.035585, 121.524365],
        [25.035794, 121.524488],
        [25.036066, 121.524558],
        [25.036183, 121.524593],
        [25.036161, 121.524732]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.tintColor = UIColor(red: 243/255.0, green: 168/255.0, blue: 34/255.0, alpha: 1)
 
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        addressTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "trigger1", name: "letFoodberGo", object: nil)
        
//        getTransitETA()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
//        regionCanChange = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //MARK: -UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        geocodeAddressString(textField.text!)
        regionCanChange = false
        
        return true
    }
    /*
    func removeAnnotation(){
        self.mapView.removeAnnotation(mapView.annotations[0])
    }
    */
    func makeAnnotation(latitude: Double, longitude: Double, title: String, move:String){
        let annotation = MyAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: title, subtitle: "")
        if title == move {
            self.moveAnnotation = annotation
        }
        self.mapView.addAnnotation(annotation)
    }
    
    func trigger1(){
        trigger2Timer.invalidate()
        trigger2Timer = nil
        let timer = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: "foodber1Run:", userInfo: nil, repeats: true)
    }
    func trigger2(){
        trigger2Timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "foodber2Run:", userInfo: nil, repeats: true)
    }
    
    func foodber1Run(timer: NSTimer){
        i++
        if i == 16{
            timer.invalidate()
        }
        if self.mapView.annotations[0].title! == "打尼尼號"{
            self.mapView.removeAnnotation(self.mapView.annotations[0])
        }else if self.mapView.annotations[1].title! == "打尼尼號"{
            self.mapView.removeAnnotation(self.mapView.annotations[1])
        }
        self.makeAnnotation(foodberLoctaion1[i][0], longitude: foodberLoctaion1[i][1], title: "打尼尼號", move:"打尼尼號")
    }
    func foodber2Run(timer: NSTimer){
        j++
        if j == 34{
            timer.invalidate()
        }
        self.mapView.removeAnnotation(self.moveAnnotation)
        self.makeAnnotation(foodberLoctaion2[j][0], longitude: foodberLoctaion2[j][1], title: "吃義燉飯", move:"吃義燉飯")
    }
}

extension MapViewController: MKMapViewDelegate{
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if self.isFirstGetLocation == false{
            isFirstGetLocation = true
            let region = MKCoordinateRegion(center: userLocation.location!.coordinate, span: MKCoordinateSpanMake(0.02, 0.02))
            mapView.region = region
            mapView.showsUserLocation = false
            iconMe.hidden = false
            
            self.makeAnnotation(foodberLoctaion2[0][0], longitude: foodberLoctaion2[0][1], title: "吃義燉飯", move:"吃義燉飯")
            trigger2()
            self.makeAnnotation(foodberLoctaion1[0][0], longitude: foodberLoctaion1[0][1], title: "打尼尼號", move:"吃義燉飯")
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
    
    //MARK: -MKDirection
//    func getTransitETA(){
//        let request = MKDirectionsRequest()
//        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 25.051501, longitude: 121.532838), addressDictionary: nil))
//        request.source = source
//        
//        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 25.045249, longitude: 121.532838), addressDictionary: nil))
//        request.destination = destination
//        
//        request.transportType = MKDirectionsTransportType.Walking
//        
//        let directions = MKDirections(request: request)
//        directions.calculateETAWithCompletionHandler { (response, error: NSError?) -> Void in
//            if error == nil{
//                if let r = response{
//                    print(" time: \(r.expectedTravelTime)")
//                }
//            }
//        }
//    }
    
   
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
        let foodbertitle = (annotation?.title)!
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MenuTableViewController") as! MenuTableViewController
        self.userLocation.address = addressTextField.text!
        
        controller.userLocation = userLocation
        controller.foodberName = foodbertitle!
        
        mapView.deselectAnnotation(annotation, animated: false)
        self.navigationController?.pushViewController(controller,animated: true)
    }
    
    
}
