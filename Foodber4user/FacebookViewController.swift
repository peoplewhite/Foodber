//
//  FacebookViewController.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/17.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookViewController: UIViewController{
    var userInformation = UserInfo()

    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.layer.cornerRadius = 15
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(red: 243/255.0, green: 168/255.0, blue: 34/255.0, alpha: 1).CGColor
        
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["public_profile", "email"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancellButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}

extension FacebookViewController: FBSDKLoginButtonDelegate{
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
            if result.token != nil{
                self.userInformation.token = result.token.tokenString
            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, id, picture, gender, birthday, email"])
                request.startWithCompletionHandler({ (sdkGraphRequestConnection, result, error) -> Void in
                    
                    let resultDictionary = result as! NSDictionary
                    
                    print("resultDictionary: \(resultDictionary)")

                    self.userInformation.name = resultDictionary["name"] as? String
                    self.userInformation.image = (resultDictionary["picture"]?["data"])?["url"] as? String
                    print("\(self.userInformation.name)\n\( self.userInformation.image)\n\(self.userInformation.token)")
                    
                    
                    let dictionary = ["userInfo": self.userInformation]
                    NSNotificationCenter.defaultCenter().postNotificationName("updateFBInfoNoti", object: nil, userInfo: dictionary)
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
            })
                
            }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logout")
    }
}
