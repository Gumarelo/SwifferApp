//
//  TimeLineViewControllerTableViewController.swift
//  SwifferApp
//
//  Created by Jorge Casariego on 27/10/14.
//  Copyright (c) 2014 Jorge Casariego. All rights reserved.
//

import UIKit

class TimeLineViewControllerTableViewController: UITableViewController {

    var timelineData:NSMutableArray! = NSMutableArray()
    
    @IBAction func loadData(){
//        var user = PFUser.currentUser()
//        var relation = user.relationForKey("Sweets")
//        var results : NSArray = NSArray()

        
        timelineData.removeAllObjects()

        var findTimelineData:PFQuery = PFQuery(className: "Sweets")
        
        findTimelineData.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]!, error:NSError!)->Void in
            
            if error == nil{
                for object in objects{
                    let sweet:PFObject = object as PFObject
                    self.timelineData.addObject(sweet)
                }
                
                NSLog("timelineData count is %i ", self.timelineData.count)
                
                let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                self.timelineData = NSMutableArray(array: array)
                
                
                self.tableView.reloadData()

            } else{
                NSLog("error " + error.localizedDescription)
            }
            
        })
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadData()
        
        if(PFUser.currentUser() == nil){
            var loginAlert:UIAlertController = UIAlertController(title: "Sign up / Login", message: "Please sign up or login", preferredStyle: UIAlertControllerStyle.Alert)
            
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your username"
            })
            
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your password"
                textfield.secureTextEntry = true
            })
            
            loginAlert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields:NSArray = loginAlert.textFields! as NSArray
                let usernameTextfield:UITextField = textFields.objectAtIndex(0) as UITextField
                let passwordTextfield:UITextField = textFields.objectAtIndex(1) as UITextField
                
                PFUser.logInWithUsernameInBackground(usernameTextfield.text, password: passwordTextfield.text){
                    (user:PFUser!, error:NSError!) -> Void in
                    if user != nil{
                        println("Login successful")
                    } else {
                        println("Login Failed")
                    }
                
                }
                
            }))
            
            
            loginAlert.addAction(UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields:NSArray = loginAlert.textFields! as NSArray
                let usernameTextfield:UITextField = textFields.objectAtIndex(0) as UITextField
                let passwordTextfield:UITextField = textFields.objectAtIndex(1) as UITextField
                
                var sweeter:PFUser = PFUser()
                sweeter.username = usernameTextfield.text
                sweeter.password = passwordTextfield.text
                
                sweeter.signUpInBackgroundWithBlock {
                    (succeeded: Bool!, error: NSError!) -> Void in
                    if error == nil {
                        println("Sign up successful")
                    } else {
                        //let errorString = error.userInfo["error"] //error.userInfo["error"] as NSString
                        println("Error")
                    }
                    
                    
                    
//                    signUpInBackgroundWithBlock{
//                    (succeeded:Bool!, error:NSError!) -> Void in
//                    if error != nil
//                        println("Sign up successful")
//                    else{
//                        let errorString = error.userInfo["error"] as String
//                        println(errorString)
//                    }
                
                    
                
                }
                
            }))

            self.presentViewController(loginAlert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:  aDecoder)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //println("Cantidad de timeline data es ", timelineData.count)
        return timelineData.count
    }

    
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell:SweetTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as SweetTableViewCell
    
    
    let sweet:PFObject = self.timelineData.objectAtIndex(indexPath.row) as PFObject

    cell.sweetTextView.alpha = 0
    cell.timestampLabel.alpha = 0
    cell.usernameLabel.alpha = 0
    
    cell.sweetTextView?.text = sweet.objectForKey("content") as? String
    
    var dataFormatter:NSDateFormatter = NSDateFormatter()
    dataFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    cell.timestampLabel.text = dataFormatter.stringFromDate(sweet.createdAt)
    
    var findSweeter:PFQuery = PFUser.query()
    findSweeter.whereKey("objectId", equalTo: sweet.objectForKey("sweeter").objectId)
    findSweeter.findObjectsInBackgroundWithBlock({
        (objects:[AnyObject]!, error:NSError!)->Void in
        
        if error == nil{
            let user:PFUser = (objects as NSArray).lastObject as PFUser
            cell.usernameLabel.text = user.username
            
            UIView.animateWithDuration(0.5, animations: {
                cell.sweetTextView.alpha = 1
                cell.timestampLabel.alpha = 1
                cell.usernameLabel.alpha = 1
                
            })
            
        } else{
            NSLog("error " + error.localizedDescription)
        }
    
    })

        return cell
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
//        
//        let sweet: PFObject = self.timelineData.objectAtIndex(indexPath.row) as PFObject
//        
//        return cell
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
