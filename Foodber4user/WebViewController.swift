//
//  WebViewController.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/27.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit
import SafariServices

class WebViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "https://www.facebook.com/letseat0528/?fref=ts")
        let controller = SFSafariViewController(URL: url!)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
