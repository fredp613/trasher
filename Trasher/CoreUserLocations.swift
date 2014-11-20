//
//  CoreUserLocations.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-20.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData

class CoreUserLocations: NSManagedObject {

    @NSManaged var defaultLocation: NSNumber
    @NSManaged var location_id: NSNumber
    @NSManaged var user: CoreUser

}
