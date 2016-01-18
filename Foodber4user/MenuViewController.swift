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
    @IBOutlet weak var shopSetButton: UIButton!
    
    override func loadView() {
        super.loadView()
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 243/255.0, green: 168/255.0, blue: 34/255.0, alpha: 1)
//        self.tabBarController?.tabBar.hidden = false
        
        self.shopListButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.shopListButton.layer.borderWidth = 1
        self.shopSetButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.shopSetButton.layer.borderWidth = 1
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.hidesBottomBarWhenPushed = true
    }
    


}
