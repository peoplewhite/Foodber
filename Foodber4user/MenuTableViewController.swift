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
    
    let menuArray = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateMenu:", name: "updateMenuNoti", object: nil)
        print("\(menuArray.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateMenu(noti: NSNotification){
        let menuArray = noti.userInfo!["foodber"] as! [Food]
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
        print("\(menu.name)")
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
