//
//  CoreTrashImage.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-23.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData

class CoreTrashImage: NSManagedObject {

    @NSManaged var trash_id: NSNumber
    @NSManaged var trash_image: NSData

}

