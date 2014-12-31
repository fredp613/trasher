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
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var type: NSNumber
    @NSManaged var trash_image: NSData
    @NSManaged var user: CoreUser
    @NSManaged var location: CoreLocation
    @NSManaged var category: CoreCategories
    @NSManaged var created_on: NSDate
    @NSManaged var updated_on: NSDate
    @NSManaged var trash_images: NSSet
    
    
//    var moc : NSManagedObjectContext = CoreDataStack().managedObjectContext!
    
    class func getTrashByUser(moc: NSManagedObjectContext) -> [CoreTrash] {
        
//        let managedObjectContext = CoreDataStack().managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "CoreTrash")
        fetchRequest.returnsObjectsAsFaults = false
        var coreTrash = [CoreTrash]()
        let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [CoreTrash]
        if fetchResults?.count > 0 {
            coreTrash = fetchResults!
        }
        return coreTrash
    }
    
  
    
    class func getRequestedTrashByUser(moc: NSManagedObjectContext) -> [CoreTrash] {
        
        let fetchRequest = NSFetchRequest(entityName: "CoreTrash")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "type == %@", false)
        fetchRequest.predicate = predicate
        var coreTrash = [CoreTrash]()
        let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [CoreTrash]
        if fetchResults?.count > 0 {
            coreTrash = fetchResults!
        }
                
        return coreTrash
       
    }
    
    class func getWantedTrashByUser(moc: NSManagedObjectContext) -> [CoreTrash] {
        
        let fetchRequest = NSFetchRequest(entityName: "CoreTrash")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "type == %@", true)
        fetchRequest.predicate = predicate
        var coreTrash = [CoreTrash]()
        let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [CoreTrash]
        if fetchResults?.count > 0 {
            coreTrash = fetchResults!
        }
        
        return coreTrash
        
    }
    
    class func getCategoryName(trash: CoreTrash) -> String {
        
        let moc = CoreDataStack().managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "CoreCategories")
        
        fetchRequest.returnsObjectsAsFaults = false
        var coreCategories = [CoreCategories]()
        var fetchResults  = moc.executeFetchRequest(fetchRequest, error: nil) as? [CoreCategories]
        
        coreCategories = fetchResults!
        
        
        for cc in coreCategories  {
            var cat = trash.category as CoreCategories?
            if cc.id == cat?.id {
                return cat?.category_name as String!
            }
        }
        return "test"
    }
    
    class func saveTrash(trash: CoreTrash, moc: NSManagedObjectContext) -> Bool {

        trash.created_on = NSDate()
        trash.updated_on = trash.created_on

        var error: NSError? = nil
        
        if moc.save(&error) {
            println("saved")
            return true
        } else {
            println("\(error?.userInfo)")
            return false
        }

        

    }
    
    class func updateTrash(moc: NSManagedObjectContext, coreTrash: CoreTrash) -> Bool {
        coreTrash.updated_on = NSDate()
        if moc.save(nil) {
            return true
        }
        return false
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
