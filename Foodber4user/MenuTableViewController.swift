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

class MenuTableViewController: UITableViewController {
    
    let foodberArray = [Foodber]()
    var menuArray = [Food]()
    let foodberName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateName:", name: "updateFoodberName", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFoodber:", name: "updateFoodber", object: nil)
        print("meunfoodber\(foodberArray.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateName(noti: NSNotification){
        let foodberName = noti.userInfo!["name"]
        print("foodberName: \(foodberName)")
    } 
    
    func updateFoodber(noti: NSNotification){
        let foodberArray = noti.userInfo!["foodber"] as! [Foodber]
        print("\(foodberArray[0])")
        for var i = 0; i < foodberArray.count; i++ {
            if foodberArray[i].name == foodberName{
                menuArray = foodberArray[i].food
                self.tableView.reloadData()
            }
        }
        print("\(menuArray.count)")
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
        cell.foodName.text! = menu.name
        cell.foodPrice.text! = "NT\(menu.price)"

        cell.plusButton.tag = indexPath.row
        cell.plusButton.addTarget(self, action: "plusCount:", forControlEvents: .TouchUpInside)
        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: "minusCount:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
//    func plusCount(sender: UIButton){
//        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuCell
//        ++self.menuArray[indexPath.row].orderCount
//        cell.counts.text = "\(self.menuArray[indexPath.row].orderCount) 份"
//    }
//    
//    func minusCount(sender: UIButton){
//        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuCell
//        if self.menuArray[indexPath.row].orderCount > 0 {
//            --self.menuArray[indexPath.row].orderCount
//            if self.menuArray[indexPath.row].orderCount > 0{
//            cell.counts.text = "\(self.menuArray[indexPath.row].orderCount) 份"
//            }else {
//            self.menuArray[indexPath.row].orderCount = 0
//            cell.counts.text = ""
//            }
//        }
//    }
}
