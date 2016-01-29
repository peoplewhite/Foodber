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
import SwiftyJSON

class DoneViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
   
    
    @IBOutlet weak var containerView: UIView!
    
    var listArray:[PFObject]!
    var userInformation = UserInfo()
    var userLocation = Location()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        
        
        if let imageUrl = userInformation.image{
            let url = NSURL(string: imageUrl)
            imageView.sd_setImageWithURL(url, placeholderImage:UIImage(named: "mapUseOfFoodber"))
        }
        
        nameLabel.text! = " " + userInformation.name!
        addressTextField.text! = userLocation.address!
        if userInformation.phoneNumber != nil{
            phoneNumber.text! = userInformation.phoneNumber!
        }
        
        let shoppinglistTableView = self.childViewControllers.first as! ShoppingListTableViewController
        shoppinglistTableView.listArray = listArray
        
        self.navigationController?.navigationBarHidden = false
        self.title = "清單"
        
        self.navigationItem.leftBarButtonItem?.title = "菜單"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done:")
        
        phoneNumber.placeholder = "電話號碼:"
        phoneNumber.keyboardType = .PhonePad
        
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tap(sender: AnyObject){
        self.view.endEditing(true)
    }
    
    func done(sender: AnyObject){
        
        
        guard phoneNumber.text! != "" else {
            alert("請輸入電話！")
            return
        }
        
        guard addressTextField.text! != "" else{
            alert("請輸入地址!")
            return
        }
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.view.window?.addSubview(activityIndicatorView)
        activityIndicatorView.center = self.view.window!.center
        activityIndicatorView.startAnimating()
        
        let orderList = PFObject(className: "OrderHistory")
        orderList["userName"] = userInformation.name!
        orderList["userNumber"] = phoneNumber.text!
        orderList["orderFood"] = listArray
        orderList["userAddress"] = userLocation.address
        orderList.saveInBackgroundWithBlock { (result: Bool, err: NSError?) -> Void in
            if result{
                let alertController = UIAlertController(title: "訂餐成功", message: nil, preferredStyle: .Alert)
                let cancelButton = UIAlertAction(title: "確認", style: .Cancel , handler: { (action: UIAlertAction) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
                alertController.addAction(cancelButton)
                NSNotificationCenter.defaultCenter().postNotificationName("letFoodberGo", object: nil)
                self.presentViewController(alertController, animated: true, completion: nil)
                activityIndicatorView.removeFromSuperview()
            }else{
                print("ohno")
            }

        }
    }
    
    func alert(title: String){
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        let cancelButton = UIAlertAction(title: "確認", style: .Cancel , handler: { (action: UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(cancelButton)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
