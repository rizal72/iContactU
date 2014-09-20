//
//  ToDoItem.swift
//  ContactU
//
//  Created by Training on 21/07/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import Foundation
import CoreData


@objc(ToDoItem)
class ToDoItem: NSManagedObject {

    @NSManaged var identifier: String
    @NSManaged var dueDate: NSDate
    @NSManaged var note: String
    @NSManaged var contact: Contact

}
