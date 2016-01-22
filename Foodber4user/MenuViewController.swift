//
//  MenuViewController.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/8.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit


class MenuViewController: UIViewController {
    
    @IBOutlet weak var shopListButton: UIButton!
    @IBOutlet weak var menuContainerView: UIView!
    
//    var menuArray = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 243/255.0, green: 168/255.0, blue: 34/255.0, alpha: 1)
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.shopListButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.shopListButton.layer.borderWidth = 1
//        NSNotificationCenter.defaultCenter().postNotificationName("updateMenuNoti", object: nil, userInfo: ["menu": menuArray])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.hidesBottomBarWhenPushed = true
    }
    
    @IBAction func showShoppingList(sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("DoneViewController") as! DoneViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

}
