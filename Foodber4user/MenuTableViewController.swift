//
//  MenuTableViewController.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/7.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit
import Parse
import SDWebImage

class MenuTableViewController: UITableViewController {
    
    var foodberName = ""
    var didOrder = false
    var total = 0
    
    var userInformation = UserInfo()
    
    var userLocation = Location()
    
    var userLogin: [PFObject]!
    
    var menuArray: [PFObject]!
    
    var orderArray = [PFObject]()
    
    
    
    var numberBut:UIButton!
    
    let customColor = UIColor(red: 243/255.0, green: 168/255.0, blue: 34/255.0, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("address: \(userLocation.address)")
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        if foodberName == "吃義燉飯"{
            let menuQuery = PFQuery(className: "Menu")
            menuQuery.findObjectsInBackgroundWithBlock { (array: [PFObject]?, error: NSError?) -> Void in
                if let array = array{
                    self.menuArray = array
                    for var i = 0; i < self.menuArray.count; i++ {
                        self.menuArray[i]["orderCount"] = 0
                    }
                    self.tableView.reloadData()
                    activityIndicatorView.removeFromSuperview()
                }
            }
        }else if foodberName == "打尼尼號"{
            let menuQuery = PFQuery(className: "Panini")
            menuQuery.findObjectsInBackgroundWithBlock { (array: [PFObject]?, error: NSError?) -> Void in
                if let array = array{
                    self.menuArray = array
                    for var i = 0; i < self.menuArray.count; i++ {
                        self.menuArray[i]["orderCount"] = 0
                    }
                    self.tableView.reloadData()
                    activityIndicatorView.removeFromSuperview()
                }
            }
        }
        
        let userQuery = PFQuery(className: "Me")
        userQuery.findObjectsInBackgroundWithBlock { (array: [PFObject]?, error: NSError?) -> Void in
            if let array = array{
                self.userLogin = array
            }
        }
        
        
        
        self.title = "菜單"
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = customColor
        
//        let cargoButton = UIBarButtonItem(image: UIImage(named: "SellStock"), style: .Plain, target: self, action: "check:")

        //self.navigationItem.rightBarButtonItems = [cargoButton]
        
        self.numberBut = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        let image = UIImage(named: "SellStock")?.imageWithRenderingMode(.AlwaysTemplate)
        self.numberBut.setImage(image, forState: .Normal)
        self.numberBut.setTitleColor(customColor, forState: .Normal)
        self.numberBut.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        numberBut.titleLabel!.font = UIFont(name: "HelveticaNeue-Regular", size: 16.0)
        numberBut.addTarget(self, action: "check:", forControlEvents: .TouchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.numberBut)
        
        //self.hidesBottomBarWhenPushed = true
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        self.numberBut.setTitle("\(0)", forState: .Normal)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFBInfo:", name: "updateFBInfoNoti", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = false
        self.tabBarController?.hidesBottomBarWhenPushed = false
        orderArray = [PFObject]()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateFBInfo(noti: NSNotification){
        let userDict = noti.userInfo as! [String: UserInfo]
        userInformation = userDict["userInfo"]!
    }
    
    func check(sender: AnyObject){
        checkOrder()
        if didOrder == false{
            showAlerController()
        }else{
            if FBSDKAccessToken.currentAccessToken() == nil{
                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("FacebookViewController") as! FacebookViewController
                controller.delegate = self
                self.presentViewController(controller, animated: true, completion: nil)
            }else{
                let me = userLogin[0]
                userInformation.name = me["name"] as? String
                userInformation.image = me["image"] as? String
//                userInformation.phoneNumber = me["phoneNumber"] as? String
                self.finishOrder()
            }
        }
    }
    
    func finishOrder() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("DoneViewController") as! DoneViewController
        controller.listArray = orderArray
        controller.userInformation = userInformation
        controller.userLocation = userLocation
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func checkOrder(){
        for var i = 0; i < menuArray.count; i++ {
            let number = menuArray[i]["orderCount"] as! Int
            if  number > 0{
                didOrder = true
                orderArray.append(menuArray[i])
            }
        }
    }
    
    func showAlerController(){
        let alertController = UIAlertController(title: "忘記點餐囉！", message: nil, preferredStyle: .Alert)
        let cancelButton = UIAlertAction(title: "點餐", style: .Cancel , handler: { (action: UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(cancelButton)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.menuArray == nil{
            return 0
        }else{
            return menuArray.count
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        cell.foodView?.image = nil
        cell.counts.text = nil
        let menu = self.menuArray[indexPath.row]

        cell.menuName.text = ("     \(menu["foodName"] as! String)")
        cell.foodPrice.text = (" NT\(menu["foodPrice"] as! Int)")
        cell.foodIntroduce.text = ("      \(menu["introduce"] as! String)")
        if (menu["orderCount"] as! Int) != 0{
            cell.counts.text = (" ×\(menu["orderCount"] as! Int)")
        }
        
        let photoFile = menu["image"] as? PFFile
        if let urlString = photoFile?.url{
            let url = NSURL(string: urlString)
            cell.foodView?.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Logo"))
        }
        
        cell.plusButton.tag = indexPath.row
        cell.plusButton.addTarget(self, action: "plusCount:", forControlEvents: .TouchUpInside)
        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: "minusCount:", forControlEvents: .TouchUpInside)
        return cell
    }
    
    func plusCount(sender: UIButton){
        total = 0
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuCell
        let count = self.menuArray[indexPath.row]["orderCount"]
        var number = count as! Int
        number++
        cell.counts.text = " ×\(number)"
        self.menuArray[indexPath.row]["orderCount"] = number
        self.numberBut.setTitle("\(countTotal())", forState: .Normal)

    }
    
    func minusCount(sender: UIButton){
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuCell
        let count = self.menuArray[indexPath.row]["orderCount"]
        var number = count as! Int
        if number > 0 {
            number--
            if number > 0{
            cell.counts.text = " ×\(number)"
            }else {
            number = 0
            cell.counts.text = ""
            }
        }
        self.menuArray[indexPath.row]["orderCount"] = number
        self.numberBut.setTitle("\(countTotal())", forState: .Normal)
    }
    
    func countTotal()-> Int{
        var total = 0
        for var i = 0; i < menuArray.count; i++ {
            let price = menuArray[i]["foodPrice"] as! Int
            let orderCount = menuArray[i]["orderCount"] as! Int
            total += price * orderCount
        }
        return total
    }
}

extension MenuTableViewController : FacebookLoginDelegate {
    
    func loginSucceed(user: UserInfo) {
        self.userInformation = user
        self.finishOrder()
    }
}
