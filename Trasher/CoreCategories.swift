//
//  CoreCategories.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-20.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData

class CoreCategories: NSManagedObject {

    @NSManaged var category_name: String
    @NSManaged var id: NSNumber
    @NSManaged var trashers: NSSet

}
