//
//  AllMenuViewController.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/2.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit

class AllMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var contentTableView: UITableView!
    override func viewDidLoad() {
        
        self.contentTableView.dataSource = self
        self.contentTableView.delegate = self
        self.contentTableView.rowHeight = UITableViewAutomaticDimension
        self.contentTableView.estimatedRowHeight = 100
        
        self.title = "Foodber"

        self.tabBarController?.tabBar.tintColor = UIColor(red: 243/255.0, green: 168/255.0, blue: 34/255.0, alpha: 1)
 
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FoodberCell", forIndexPath: indexPath)
        cell.imageView?.image = nil
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        self.navigationController?.pushViewController(controller,animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        
    }

}
