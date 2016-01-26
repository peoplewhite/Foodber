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

class MenuTableViewController: UITableViewController {
    
    var foodberArray = [Foodber]()
    var menuArray = [Food]()
    var orderArray:[Food]!
    var foodberName = ""
    var didOrder = false
    var total = 0
    
    var userInformation = UserInfo()
    
    var userLocation = Location()
    
    override func loadView() {
        super.loadView()
        for var i = 0; i < foodberArray.count; i++ {
            if foodberArray[i].name == foodberName{
                menuArray = foodberArray[i].food
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Menu"
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 243/255.0, green: 168/255.0, blue: 34/255.0, alpha: 1)
        
//        let totalButton = UIBarButtonItem(title: "NT \(total)", style: .Plain, target: nil, action: nil)
        let cargoButton = UIBarButtonItem(image: UIImage(named: "SellStock"), style: .Plain, target: self, action: "check:")
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done:")
        self.navigationItem.rightBarButtonItems = [cargoButton]
        self.hidesBottomBarWhenPushed = true
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFBInfo:", name: "updateFBInfoNoti", object: nil)
    
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
                self.presentViewController(controller, animated: true, completion: nil)
            }else{
                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("DoneViewController") as! DoneViewController
                controller.listArray = orderArray
                controller.userInformation = userInformation
                controller.userLocation = userLocation
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func checkOrder(){
        orderArray = [Food]()
        for var i = 0; i < menuArray.count; i++ {
            if menuArray[i].orderCount != 0{
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
        return menuArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        let menu = self.menuArray[indexPath.row]
        cell.foodName.text! = "\(menu.name)"
        cell.foodPrice.text! = " NT\(menu.price)"
        cell.plusButton.tag = indexPath.row
        cell.plusButton.addTarget(self, action: "plusCount:", forControlEvents: .TouchUpInside)
        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: "minusCount:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func plusCount(sender: UIButton){
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuCell
        ++self.menuArray[indexPath.row].orderCount
        cell.counts.text = "× \(self.menuArray[indexPath.row].orderCount)"
    }
    
    func minusCount(sender: UIButton){
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuCell
        if self.menuArray[indexPath.row].orderCount > 0 {
            --self.menuArray[indexPath.row].orderCount
            if self.menuArray[indexPath.row].orderCount > 0{
            cell.counts.text = "× \(self.menuArray[indexPath.row].orderCount)"
            }else {
            self.menuArray[indexPath.row].orderCount = 0
            cell.counts.text = ""
            }
        }
    }
}
