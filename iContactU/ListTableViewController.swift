//
//  ListTableViewController.swift
//  ContactU
//
//  Created by Training on 21/07/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ListTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    var toDoItems:NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refresh = UIRefreshControl()
        refresh.tintColor = UIColor.blackColor()
        refresh.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh...", comment: "refresh"))
        
        self.refreshControl = refresh
        self.refreshControl?.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        
        loadData()
        
    }
    
    func refreshData(){
        loadData()
    }
    
    func loadData(indexPath:NSIndexPath? = nil){
        toDoItems.removeAllObjects()
        
        let results:NSArray = ToDoItem.findAll(predicate: nil, sortedBy: "dueDate", ascending: true, contextType: BreezeContextType.Background)
        
        if results.count > 0 {
            
            //self.refreshControl?.beginRefreshing()
            
            for toDo in results{
                let singleToDoItem:ToDoItem = toDo as ToDoItem
                
                let contact:Contact = singleToDoItem.contact
                
                let dict:NSDictionary = ["identifier":singleToDoItem.identifier,"name":contact.name, "email":contact.email, "phone":contact.phone, "dueDate":singleToDoItem.dueDate, "note":singleToDoItem.note, "profileImage":UIImage(data: contact.contactImage)!]
                
                toDoItems.addObject(dict)
                
            }
            
        }
        if(self.refreshControl?.refreshing == true){
            self.refreshControl?.endRefreshing()
        }
        
        if (indexPath != nil){
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            //println("deleting row with animation...")
        }
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return toDoItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ListTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as ListTableViewCell
        
        cell.alpha = 0
        
        let infoDict:NSDictionary = toDoItems.objectAtIndex(indexPath.row) as NSDictionary
        
        let name:NSString = infoDict.objectForKey("name") as NSString
        //let lastName:NSString = infoDict.objectForKey("lastName") as NSString
        
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "dd MMMM - HH:mm"
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let dateString:NSString = dateFormatter.stringFromDate(infoDict.objectForKey("dueDate") as NSDate)
        
        cell.contactImageView.image = (infoDict.objectForKey("profileImage") as UIImage)
        cell.nameLabel.text = name
        cell.noteLabel.text = infoDict.objectForKey("note") as NSString
        cell.dueDateLabel.text = dateString
        
        cell.callButton.tag = indexPath.row
        cell.textButton.tag = indexPath.row
        cell.mailButton.tag = indexPath.row
        
        cell.callButton.addTarget(self, action: "callSomeOne:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.textButton.addTarget(self, action: "textSomeOne:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.mailButton.addTarget(self, action: "mailSomeOne:", forControlEvents: UIControlEvents.TouchUpInside)
        
        UIView.animateWithDuration(0.5, animations: {
            cell.alpha = 1
        })
        
        return cell
    }
    
    func callSomeOne(sender:UIButton){
        let infoDict:NSDictionary = toDoItems.objectAtIndex(sender.tag) as NSDictionary
        
        var phoneNumber = infoDict.objectForKey("phone") as NSString
        var phoneNumberStripped = phoneNumber.stringByReplacingOccurrencesOfString("\u{00a0}", withString: "")
        //println("phoneNumberStripped: \(phoneNumberStripped)")
        UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://\(phoneNumberStripped)")!)
        
    }
    
    func textSomeOne(sender:UIButton){
        let infoDict:NSDictionary = toDoItems.objectAtIndex(sender.tag) as NSDictionary
        let phoneNumber = infoDict.objectForKey("phone") as NSString
        
        if MFMessageComposeViewController.canSendText() {
            let messageController:MFMessageComposeViewController = MFMessageComposeViewController()
            messageController.recipients = ["\(phoneNumber)"]
            messageController.messageComposeDelegate = self
            
            self.presentViewController(messageController, animated: true, completion: nil)
            
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        // Does not work in Beta 4
        /*switch result.value{
        case MessageComposeResultSent.value:
        controller.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultCancelled.value:
        controller.dismissViewControllerAnimated(true, completion: nil)
        default:
        controller.dismissViewControllerAnimated(true, completion: nil)
        }*/
        
        
    }
    
    func mailSomeOne(sender:UIButton){
        let infoDict:NSDictionary = toDoItems.objectAtIndex(sender.tag) as NSDictionary
        let email = infoDict.objectForKey("email") as NSString
        
        if MFMailComposeViewController.canSendMail() {
            let messageController:MFMailComposeViewController = MFMailComposeViewController()
            messageController.setToRecipients(["\(email)"])
            messageController.mailComposeDelegate = self
            
            self.presentViewController(messageController, animated: true, completion: nil)
            
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        // Does not work in Beta 4
        /*switch result.value{
        case MFMailComposeResultCancelled.value:
        controller.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultSent.value:
        controller.dismissViewControllerAnimated(true, completion: nil)
        default:
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        }*/
        
    }
    
    func deleteNotification(id:String){
        
        var notifications = UIApplication.sharedApplication().scheduledLocalNotifications
        
        for n in notifications{
            let notification:UILocalNotification = n as UILocalNotification
            
            if ((notification.userInfo!["ID"]! as String) == id){
                
                //println("notification to delete: \(notification)")
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            if (toDoItems.count > 0){
                
                let infoDict:NSDictionary = toDoItems.objectAtIndex(indexPath.row) as NSDictionary
                let identifier:NSString = infoDict.objectForKey("identifier") as NSString
                let predicate:NSPredicate! = NSPredicate(format: "identifier == '\(identifier)'")
                let toDoItemToDelete:ToDoItem = ToDoItem.findFirst(attribute: "identifier", value: identifier, contextType: BreezeContextType.Background) as ToDoItem
                
                deleteNotification(toDoItemToDelete.identifier)
                
                toDoItemToDelete.deleteInContextOfType(BreezeContextType.Background)
                
                BreezeStore.saveInBackground({ contextType -> Void in
                    },
                    completion: {error -> Void in
                        //println("saved.")
                        self.loadData(indexPath: indexPath)
                })

            }
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
