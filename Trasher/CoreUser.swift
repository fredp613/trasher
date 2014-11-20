//
//  CoreUser.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-20.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData

class CoreUser: NSManagedObject {

    @NSManaged var email: String
    @NSManaged var id: NSNumber
    @NSManaged var tutorial_complete: NSNumber
    @NSManaged var username: String
    @NSManaged var verified: NSNumber
    @NSManaged var remember: NSNumber
    @NSManaged var categories: NSSet
    @NSManaged var locations: NSSet

}
