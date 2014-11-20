//
//  CoreTrash.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-20.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData

class CoreTrash: NSManagedObject {

    @NSManaged var desc: String
    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var trash_image: NSData
    @NSManaged var location: CoreLocation
    @NSManaged var category: CoreCategories

}
