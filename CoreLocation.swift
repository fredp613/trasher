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
    @NSManaged var country_code: String
    @NSManaged var default_location: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var trasher: CoreTrash
    @NSManaged var user: CoreUser
    
    class func getDefaultLocationByUser(moc: NSManagedObjectContext) -> CoreLocation? {
        let fetchRequest = NSFetchRequest(entityName: "CoreLocation")
        
        let predicate = NSPredicate(format: "default_location == %@", true)
        fetchRequest.predicate = predicate
        
        var coreLocation : [CoreLocation]? = [CoreLocation]()
        
        var error : NSError? = nil
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: &error) as? [CoreLocation] {
            coreLocation = fetchResults
            if coreLocation?.count > 0 {
                return coreLocation?[0]
            }
            
        } else {
            println("\(error?.userInfo)")
        }

        return nil
    }
    
    class func removeCurrentDefault(moc: NSManagedObjectContext) -> Bool {
        let cl = getDefaultLocationByUser(moc)
        cl?.default_location = false
        if moc.save(nil) {
            return true
        }
        return false
    }
    
    
    class func getAllUserLocations(moc: NSManagedObjectContext) -> [CoreLocation]? {
        let fetchRequest = NSFetchRequest(entityName: "CoreLocation")
        
        var cl : [CoreLocation] = [CoreLocation]()
        
        var error : NSError? = nil
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: &error) as? [CoreLocation] {
            cl = fetchResults
            return cl
        } else {
            println(error?.userInfo)
        }
           return nil
    }
    
    class func locationExists(moc: NSManagedObjectContext, latitude: NSNumber, longitude: NSNumber) -> CoreLocation? {
        
        let fetchRequest = NSFetchRequest(entityName: "CoreLocation")
        let predicateLat = NSPredicate(format: "latitude == %lf", latitude.floatValue)
        let predicateLong = NSPredicate(format: "longitude == %lf", longitude.floatValue)
        println(latitude)
        let compoundPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [predicateLat, predicateLong])
        fetchRequest.predicate = compoundPredicate
        
        var coreLocation : [CoreLocation] = [CoreLocation]()
        
        var error : NSError? = nil
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: &error) as? [CoreLocation] {
            coreLocation = fetchResults
            println(coreLocation.count)
            if fetchResults.count > 0 {
               return fetchResults[0]
            }
            return nil
        }
        

        return nil
    }
    
      
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
