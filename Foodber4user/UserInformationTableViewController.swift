//
//  UserInformationTableViewController.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/27.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit
import Parse
import SafariServices


class UserInformationTableViewController: UITableViewController, UITextFieldDelegate{

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhoneNumber: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    var userInformation: [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.layer.cornerRadius = 10
        userImage.clipsToBounds = true
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
            self.userPhoneNumber.text = myInform["phoneNumber"] as? String
            self.userEmail.text = myInform["mail"] as? String
        }
        
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        self.view.addGestureRecognizer(tap)
        
        userPhoneNumber.keyboardType = .NumberPad
    }
    
    func tap(sender: AnyObject){
        self.view.endEditing(true)
    }

    @IBAction func aboutUs(sender: AnyObject) {
        let url = NSURL(string: "https://www.facebook.com/letseat0528/?fref=ts")
        let controller = SFSafariViewController(URL: url!)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 3
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

