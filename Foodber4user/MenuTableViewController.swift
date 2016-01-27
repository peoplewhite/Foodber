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
    
    
    override func viewDidLoad() {
        
        let menuQuery = PFQuery(className: "Menu")
        menuQuery.findObjectsInBackgroundWithBlock { (array: [PFObject]?, error: NSError?) -> Void in
            if let array = array{
                self.menuArray = array
                self.tableView.reloadData()
            }
        }
        
        super.viewDidLoad()
        self.title = "Menu"
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 243/255.0, green: 168/255.0, blue: 34/255.0, alpha: 1)
        
        let cargoButton = UIBarButtonItem(image: UIImage(named: "SellStock"), style: .Plain, target: self, action: "check:")

        self.navigationItem.rightBarButtonItems = [cargoButton]
        self.hidesBottomBarWhenPushed = true
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFBInfo:", name: "updateFBInfoNoti", object: nil)
        let userQuery = PFQuery(className: "Me")
        userQuery.findObjectsInBackgroundWithBlock { (array: [PFObject]?, error: NSError?) -> Void in
            if let array = array{
                self.userLogin = array
            }
        }
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

        cell.menuName.text = menu["foodName"] as? String
        cell.foodPrice.text = (" NT\(menu["foodPrice"] as! Int)")
        
        if (menu["orderCount"] as! Int) != 0{
        cell.counts.text = ("× \(menu["orderCount"] as! Int)")
        }
        
        let photoFile = menu["image"] as? PFFile
        if let urlString = photoFile?.url{
            let url = NSURL(string: urlString)
            cell.foodView?.sd_setImageWithURL(url, placeholderImage: UIImage(named: "mapUseOfFoodber"))
        }
        
        cell.plusButton.tag = indexPath.row
        cell.plusButton.addTarget(self, action: "plusCount:", forControlEvents: .TouchUpInside)
        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: "minusCount:", forControlEvents: .TouchUpInside)
        return cell
    }
    
    func plusCount(sender: UIButton){
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuCell
        let count = self.menuArray[indexPath.row]["orderCount"]
        var number = count as! Int
        number++
        
        cell.counts.text = "× \(number)"
        self.menuArray[indexPath.row]["orderCount"] = number
    }
    
    func minusCount(sender: UIButton){
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuCell
        let count = self.menuArray[indexPath.row]["orderCount"]
        var number = count as! Int
        
        if number > 0 {
            number--
            if number > 0{
            cell.counts.text = "× \(number)"
            }else {
            number = 0
            cell.counts.text = ""
            }
        }
        self.menuArray[indexPath.row]["orderCount"] = number
    }
}

extension MenuTableViewController : FacebookLoginDelegate {
    
    func loginSucceed(user: UserInfo) {
        self.userInformation = user
        self.finishOrder()
    }
}
