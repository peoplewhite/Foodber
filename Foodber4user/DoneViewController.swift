//
//  DoneViewController.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/19.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit
import SDWebImage
import Parse

class DoneViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
   
    
    @IBOutlet weak var containerView: UIView!
    
    var listArray = [Food]()
    var userInformation = UserInfo()
    var userLocation = Location()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
        if let imageUrl = userInformation.image{
            let url = NSURL(string: imageUrl)
            imageView.sd_setImageWithURL(url, placeholderImage:UIImage(named: "mapUseOfFoodber"))
        }
        
        nameLabel.text! = userInformation.name!
        addressTextField.text! = userLocation.address!
        
        let shoppinglistTableView = self.childViewControllers.first as! ShoppingListTableViewController
        shoppinglistTableView.listArray = listArray
        
        self.navigationController?.navigationBarHidden = false
        self.title = "List"
        
        self.navigationItem.leftBarButtonItem?.title = "Menu"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done:")
        
        phoneNumber.placeholder = "電話號碼:"
        phoneNumber.keyboardType = .PhonePad

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func done(sender: AnyObject){
        let orderList = PFObject(className: "OrderHistory")
        orderList["userName"] = userInformation.name!
//        orderList["userNumber"] = phoneNumber.text!
        orderList["orderFood"] = listArray
        orderList["userAddress"] = userLocation.address
        orderList.saveInBackgroundWithBlock { (result: Bool, err: NSError?) -> Void in
            if result{
                print("ohya")
            }else{
                print("ohno")
            }
        }
    }
}
