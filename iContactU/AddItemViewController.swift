//
//  AddItemViewController.swift
//  ContactU
//
//  Created by Training on 21/07/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController, ContactSelectionDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var contactImageView: UIImageView! = UIImageView()
    @IBOutlet weak var nameLabel: UILabel! = UILabel()
    @IBOutlet weak var noteTextField: UITextField! = UITextField()
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    var selectedContact:Contact? = nil
    var contactIdentifierString:String = String()
    var datePicked:NSDate = NSDate()
    var globalIdentifier:String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickerChanged(sender: UIDatePicker) {
        datePicked = sender.date
        
    }
    
    @IBAction func done(sender: AnyObject) {
        
        if (selectedContact != nil){
            
            self.globalIdentifier = "\(NSDate())"
            
            BreezeStore.saveInBackground{ contextType -> Void in
                let toDoItem = ToDoItem.createInContextOfType(contextType) as ToDoItem
                toDoItem.identifier = self.globalIdentifier
                toDoItem.dueDate = self.datePickedRounded()
                toDoItem.note = self.noteTextField.text
                toDoItem.contact = self.selectedContact!
            }
            
            if(reminderSwitch.on)
            {
                //println("creating reminder...")
                createReminder();
            }
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    func datePickedRounded() -> NSDate{
        
        //ROUNDING FOR SECONDS
        let seconds:NSTimeInterval = floor(datePicked.timeIntervalSinceReferenceDate / 60.0)*60.0
        let rounded = NSDate(timeIntervalSinceReferenceDate: seconds)
        
        return rounded
    }
    
    func createReminder(){
        
        var reminder = UILocalNotification()
        reminder.timeZone = NSTimeZone.defaultTimeZone()
        
        //println("prima: \(datePicked)")
        reminder.fireDate = datePickedRounded()
        //println("dopo: \(reminder.fireDate!)")
        
        reminder.userInfo = ["ID" : globalIdentifier]
        reminder.applicationIconBadgeNumber = 1
        reminder.alertBody =  NSLocalizedString("You have to contact ", comment: "reminder") + "\(self.selectedContact!.name)"
        reminder.soundName = UILocalNotificationDefaultSoundName;
        UIApplication.sharedApplication().scheduleLocalNotification(reminder)
    }
    
    func userDidSelectContact(contactIdentifier: String) {
        contactIdentifierString = contactIdentifier
        
        //Find with predicate
        /*let predicate:NSPredicate = NSPredicate(format: "identifier == '\(contactIdentifier)'")
        let contact:Contact = Contact.findFirst(predicate: predicate, sortedBy: "identifier", ascending: true, contextType: BreezeContextType.Background) as Contact*/
        
        let contact:Contact = Contact.findFirst(attribute: "identifier", value: "\(contactIdentifier)", contextType: BreezeContextType.Background) as Contact
        
        selectedContact = contact
        
        contactImageView.image = UIImage(data: contact.contactImage)
        
        nameLabel.text = contact.name
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        noteTextField.resignFirstResponder()
    }
    
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "contactsSegue"{
            let destinationViewController:ContactsTableViewController = segue.destinationViewController as ContactsTableViewController
            
            destinationViewController.delegate = self
            
        }
    }
    
}
