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
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
        if let imageUrl = userInformation.image{
            let url = NSURL(string: imageUrl)
            imageView.sd_setImageWithURL(url, placeholderImage:UIImage(named: "mapUseOfFoodber"))
        }
        
        nameLabel.text! = userInformation.name!
        addressTextField.text! = userLocation.address!
        if userInformation.phoneNumber != nil{
            phoneNumber.text! = userInformation.phoneNumber!
        }
        
        let shoppinglistTableView = self.childViewControllers.first as! ShoppingListTableViewController
        shoppinglistTableView.listArray = listArray
        
        self.navigationController?.navigationBarHidden = false
        self.title = "List"
        
        self.navigationItem.leftBarButtonItem?.title = "Menu"
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
        
        let orderList = PFObject(className: "OrderHistory")
        orderList["userName"] = userInformation.name!
        orderList["userNumber"] = phoneNumber.text!
        orderList["orderFood"] = listArray
        orderList["userAddress"] = userLocation.address
        //        orderList["token"] = userInformation.token
        orderList.saveInBackgroundWithBlock { (result: Bool, err: NSError?) -> Void in
            if result{
                let alertController = UIAlertController(title: "訂餐成功", message: nil, preferredStyle: .Alert)
                let cancelButton = UIAlertAction(title: "等待大餐", style: .Cancel , handler: { (action: UIAlertAction) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
                alertController.addAction(cancelButton)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }else{
                print("ohno")
            }

        }
    }
    
//    func getListArray()->[[String:String]] {
//    
//        var array = [[String:String]]()
//        
//        for food in listArray {
//            let dict = food.getDictionary()
//            array.append(dict)
//        }
//        
//        return array
//    }
    
    func alert(title: String){
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        let cancelButton = UIAlertAction(title: "確認", style: .Cancel , handler: { (action: UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(cancelButton)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
