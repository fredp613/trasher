//
//  CoreUserCategories.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-20.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData

class CoreUserCategories: NSManagedObject {

    @NSManaged var category_id: NSNumber
    @NSManaged var users: NSSet

}
