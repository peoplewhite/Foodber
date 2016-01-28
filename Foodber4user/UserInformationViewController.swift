//
//  UserInformationViewController.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/27.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit
import Parse

class UserInformationViewController: UIViewController {
    
    var userInformation: [PFObject]!

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let userQuery = PFQuery(className: "Me")
        userQuery.findObjectsInBackgroundWithBlock { (array: [PFObject]?, error: NSError?) -> Void in
            if let array = array{
                self.userInformation = array
            }
            let myInform = self.userInformation[0]
            if let imageUrl = myInform["image"]{
                let url = NSURL(string: imageUrl as! String)
                self.userImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "mapUseOfFoodber"))
            }
            self.userName.text = myInform["name"] as? String
        }
        
        userImage.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
