//
//  MenuTableViewController.swift
//  Foodber4user
//
//  Created by linyuta on 2016/1/7.
//  Copyright © 2016年 linyuta. All rights reserved.
//

import UIKit
import Alamofire 

class MenuTableViewController: UITableViewController {

//    var shoppingListButton: UIButton!
    var dataArray = NSMutableArray()
    var countNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        alamoFireDownload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alamoFireDownload(){
        let url = "https://warm-lowlands-8026.herokuapp.com/api/v1/articles"
        Alamofire.request(.GET, url).responseJSON { response in
            if let JSON = response.result.value
            {
                print("JSON: \(JSON)")
                self.dataArray = JSON["data"] as! NSMutableArray
                //self.jsonArray = JSON["result"]!!["results"] as! NSMutableArray
                //print(self.jsonArray)
                
            }
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        let dic = self.dataArray[indexPath.row]
        cell.foodName.text = dic["topic"] as? String
        cell.foodPrice.text = dic["price"] as? String
        cell.plusButton.tag = indexPath.row
        cell.plusButton.addTarget(self, action: "plusCount:", forControlEvents: .TouchUpInside)
        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: "minusCount:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func plusCount(sender: UIButton){
        ++countNumber
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuCell
        cell.counts.text = "\(countNumber) 份"
    }
    
    func minusCount(sender: UIButton){
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuCell
        if countNumber > 0 {
            --countNumber
            if countNumber > 0 {
                cell.counts.text = "\(countNumber) 份"
            }else if countNumber == 0{
                cell.counts.text = "\(countNumber) 份"
            }
        }
    }

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
