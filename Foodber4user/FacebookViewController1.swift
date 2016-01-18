//
//  FacebookViewController.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/12.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FacebookViewController1: UIViewController {

    override func viewDidLoad(){
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getProfileNoti:", name: FBSDKProfileDidChangeNotification, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func getProfileNoti(noti:NSNotification){
       
        let profile = FBSDKProfile.currentProfile()
        print("profile \(profile)")
        
    }
    
    @IBAction func fbLoginButton(sender: AnyObject) {
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["email"], fromViewController: nil) { (result: FBSDKLoginManagerLoginResult!, err: NSError!) -> Void in
            if err != nil{
                
            }
            else if result.isCancelled{
                
            }
            else{
                if result.grantedPermissions.contains("email"){
                    FBSDKAccessToken.currentAccessToken().userID
//                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewController")
//                    self.presentViewController(controller!, animated: false, completion: nil)
                }
            }
        }
        
    }
}
