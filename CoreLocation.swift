//
//  Trasher.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-12-30.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData

class CoreLocation: NSManagedObject {

    @NSManaged var addressline1: String
    @NSManaged var addressline2: String
    @NSManaged var city: String
    @NSManaged var country: String
    @NSManaged var created_on: NSDate
    @NSManaged var id: NSNumber
    @NSManaged var state: String
    @NSManaged var updated_on: NSDate
    @NSManaged var zip: String
    @NSManaged var default_location: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var trasher: CoreTrash
    @NSManaged var user: CoreUser
    
    class func getDefaultLocationByUser(moc: NSManagedObjectContext) -> CoreLocation? {
        let fetchRequest = NSFetchRequest(entityName: "CoreLocation")
        
//        let predicate = NSPredicate(format: "default_location == %@", true)
//        fetchRequest.predicate = predicate
        
        var coreLocation : [CoreLocation]? = [CoreLocation]()
        
        var error : NSError? = nil
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: &error) as? [CoreLocation] {
            coreLocation = fetchResults
        } else {
            println("\(error?.userInfo)")
        }
        if coreLocation?.count > 0 {
            return coreLocation?[0]
        }
        return nil
    }

}
