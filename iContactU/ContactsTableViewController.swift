//
//  ContactsTableViewController.swift
//  ContactU
//
//  Created by Training on 21/07/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import CoreData
import UIKit

protocol ContactSelectionDelegate{
    func userDidSelectContact(identifier:String)
}


class ContactsTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let addressBook = APAddressBook()
    var yourContacts:NSArray = NSArray()
    var contactsIndexTitles:NSMutableArray = NSMutableArray()
    var delegate:ContactSelectionDelegate? = nil
    var activity:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initActivityIndicator()
        searchBar.delegate = self
        loadContacts()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func initActivityIndicator (){
        
        activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activity.frame = CGRectMake(self.view.frame.size.width/2 - 10, self.view.frame.size.height/2 - 10, 20, 20)
        
        self.view.addSubview(activity)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        loadContacts(searchString: searchText)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.text = ""
        
        loadContacts()
        searchBar.resignFirstResponder()
    }
    
    func loadContacts(searchString:String = ""){
        
        activity.startAnimating()
        
        self.addressBook.fieldsMask = APContactField.Default | APContactField.Thumbnail | APContactField.CompositeName | APContactField.Emails
        self.addressBook.sortDescriptors = [NSSortDescriptor(key: "compositeName", ascending: true)]
        
        self.addressBook.filterBlock = {(contact: APContact!) -> Bool in
            
            //CHECK IF CONTACT HAS PHONES
            var isElegible = contact.phones.count > 0 && contact.compositeName != nil
            
            //CHECK IF USER IS SEARCHING A CONTACT
            if(countElements(searchString) > 0 && isElegible){
                isElegible = contact.compositeName.lowercaseString.rangeOfString(searchString.lowercaseString) != nil
            }
            
            return isElegible
        }
        
        self.addressBook.loadContacts(
            { (contacts: [AnyObject]!, error: NSError!) in
                
                if (contacts != nil) {
                    
                    //self.yourContacts = contacts as NSArray
                    self.yourContacts = self.partitionObjects(contacts as NSArray, collationStringSelector: "compositeName")
                    self.tableView.reloadData()
                    
                }
                else if (error != nil) {
                    
                    let alert = UIAlertView(title: "Error", message: error.localizedDescription,
                        delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                    
                }
        })
        
        activity.stopAnimating()
    }
    
    func partitionObjects(array:NSArray, collationStringSelector:Selector) -> NSArray{
        
        let collation:UILocalizedIndexedCollation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation
        
        //section count is take from sectionTitles and not sectionIndexTitles
        let sectionCount = collation.sectionTitles.count
        
        let unsortedSections = NSMutableArray(capacity: sectionCount)
        
        //create an array to hold the data for each section
        for i in collation.sectionTitles{
            var emptyArray = NSMutableArray()
            unsortedSections.addObject(emptyArray);
        }
        
        //put each object into a section
        for object in array{
            let index:Int = collation.sectionForObject(object, collationStringSelector: collationStringSelector)
            unsortedSections.objectAtIndex(index).addObject(object)
        }
        
        var sections = NSMutableArray(capacity: sectionCount)
        
        //sort each section
        for section in unsortedSections{
            sections.addObject(collation.sortedArrayFromArray(section as NSMutableArray, collationStringSelector: collationStringSelector))
        }
        
        return sections;
    }
    
    func saveContactAndPop(contactToSave:APContact){
        
        var id:String = "\(NSDate())"
        
        BreezeStore.saveInBackground({ contextType -> Void in
            let contact = Contact.createInContextOfType(contextType) as Contact
            
            contact.identifier = id
            contact.name =  contactToSave.compositeName != nil ? contactToSave.compositeName : ""
            
            contact.email = contactToSave.emails.count > 0 ? contactToSave.emails[0] as String : ""
            contact.phone = contactToSave.phones.count > 0 ? contactToSave.phones[0] as String : ""
            
            if(contactToSave.thumbnail != nil){
                contact.contactImage =  UIImagePNGRepresentation(contactToSave.thumbnail)
            }
            else{
                contact.contactImage = UIImagePNGRepresentation(UIImage(named: "dummy"))
            }
            }, completion:{error -> Void in
                if(error != nil){
                    println("\(error?.localizedDescription)")
                }else{
                    //println("contact saved!")
                    self.pop(id)
                }
        })
        
    }
    
    func pop(identifier:String){
        delegate?.userDidSelectContact(identifier)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        var numberOfSections = UILocalizedIndexedCollation.currentCollation().sectionTitles.count
        //println("numberOfSections: \(numberOfSections)")
        return numberOfSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return (yourContacts.count > 0) ? yourContacts.objectAtIndex(section).count : 0
    }
    
    /*override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var showSection:Bool = yourContacts?.objectAtIndex(section).count != 0
    
    //only show the section title if there are rows in the section
    return (showSection) ? (UILocalizedIndexedCollation.currentCollation().sectionTitles[section] as String) : nil;
    
    }*/
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ContactCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as ContactCellTableViewCell
        
        if(yourContacts.count > 0){
            let contact = yourContacts[indexPath.section][indexPath.row] as APContact
            
            cell.nameLabel.text = contact.compositeName != nil ? contact.compositeName : ""
            cell.phoneLabel.text = contact.phones.count > 0 ? contact.phones[0] as String : ""
            cell.emailLabel.text = contact.emails.count > 0 ? contact.emails[0] as String : ""
            
            //IMAGE:
            
            //RESIZING DONE IN CUSTOM TABLE CELL !!!!
            //cell.contactImageView.frame = CGRectMake(0, 0, 75, 75)
            
            if (contact.thumbnail != nil){
                cell.contactImageView.image = contact.thumbnail
            }else{
                cell.contactImageView.image = UIImage(named: "dummy")
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let contact = yourContacts[indexPath.section][indexPath.row] as APContact
        saveContactAndPop(contact)
    }
    
    //INDEX:
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        //sectionForSectionIndexTitleAtIndex: is a bit buggy, but is still useable
        return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index)
        
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return UILocalizedIndexedCollation.currentCollation().sectionIndexTitles
    }
}
