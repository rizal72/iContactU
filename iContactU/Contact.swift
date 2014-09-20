//
//  Contact.swift
//  ContactU
//
//  Created by Training on 21/07/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import Foundation
import CoreData


@objc(Contact)
class Contact: NSManagedObject {

    @NSManaged var identifier: String
    @NSManaged var name: String
    //@NSManaged var lastName: String
    @NSManaged var phone: String
    @NSManaged var email: String
    @NSManaged var contactImage: NSData
    @NSManaged var toDoItem: NSSet

}
