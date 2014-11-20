//
//  CoreLocation.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-20.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData

class CoreLocation: NSManagedObject {

    @NSManaged var addressline1: String
    @NSManaged var addressline2: String
    @NSManaged var city: String
    @NSManaged var country: String
    @NSManaged var id: NSNumber
    @NSManaged var state: String
    @NSManaged var zip: String
    @NSManaged var trashers: NSSet

}


