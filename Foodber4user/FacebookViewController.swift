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
    var myInformation = UserInfo()

    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["public_profile", "email"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension FacebookViewController: FBSDKLoginButtonDelegate{
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
            if result.token != nil{
            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, id, picture, gender, birthday, email"])
            request.startWithCompletionHandler({ (sdkGraphRequestConnection, result, error) -> Void in
                if error == nil{
                    print("result: \(result)")
                    let resultDictionary = result as! NSDictionary
                    self.myInformation.token = result.tokenString 
                    self.myInformation.name = resultDictionary["name"] as? String
                    self.myInformation.userId = resultDictionary["userId"] as? String
                    self.myInformation.image = resultDictionary["picture"] as? String
                    print("pic \(self.myInformation.image)")
                    print("name \(self.myInformation.name)")
                    print("token \(self.myInformation.token)")
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
            })
            }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logout")
    }
}
