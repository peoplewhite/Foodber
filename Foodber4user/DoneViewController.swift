//
//  DoneViewController.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/19.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit

class DoneViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLable: UILabel!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.title = "ShoppingList"
        
        self.navigationItem.leftBarButtonItem?.title = "Menu"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done:")
//        imageView.layer.borderWidth = 1.0
//        imageView.layer.masksToBounds = false
//        imageView.layer.borderColor = UIColor.whiteColor().CGColor
//        imageView.layer.cornerRadius = imageView.frame.width / 2
//        imageView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func done(sender: AnyObject){
        
    }
}
