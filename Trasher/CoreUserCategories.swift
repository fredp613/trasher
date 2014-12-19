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

//    @NSManaged var category_id: NSNumber
//    @NSManaged var userId: NSNumber
    
    @NSManaged var user_id: String
    @NSManaged var category_id: NSNumber
    @NSManaged var uc_id: String
    
    class func generateDefaultCategoriesForNewUser(moc: NSManagedObjectContext, currentUser: CoreUser) -> Bool {
        
        //here go to web server and fetch latest categories (to do)
        
        let defaultCategories : [CoreCategories] = CoreCategories.generateCategories(moc)
        
        if defaultCategories.count > 0 {
        
            for cat in defaultCategories {
                let ccUserCat : CoreUserCategories = NSEntityDescription.insertNewObjectForEntityForName("CoreUserCategories", inManagedObjectContext: moc) as CoreUserCategories
                ccUserCat.uc_id = NSUUID().UUIDString
                ccUserCat.category_id = CoreCategories.findCategoryById(moc, id: cat.id).id
                ccUserCat.user_id = currentUser.id
            }
            
            if moc.save(nil) {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    class func retrieveUserCategories(managedObjectContext: NSManagedObjectContext) -> [CoreUserCategories] {
        
        let moc : NSManagedObjectContext = managedObjectContext
        let cu = CoreUser.currentUser(moc)
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CoreUserCategories")
        var coreUserCategories = [CoreUserCategories]()
        
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [CoreUserCategories] {
            coreUserCategories = fetchResults
        }
        
        return coreUserCategories
        
    }
    
    class func insertUserCategory(moc: NSManagedObjectContext, category_id: NSNumber) -> Bool {
        
        let currentUser : CoreUser = CoreUser.currentUser(moc)
        
        let ccUserCat : CoreUserCategories = NSEntityDescription.insertNewObjectForEntityForName("CoreUserCategories", inManagedObjectContext: moc) as CoreUserCategories
        
        ccUserCat.uc_id = NSUUID().UUIDString
        ccUserCat.category_id = CoreCategories.findCategoryById(moc, id: category_id).id
        ccUserCat.user_id = currentUser.id
        
        if moc.save(nil) {
             println("\(CoreUserCategories.retrieveUserCategories(moc).count)")
            return true
        } else {
            return false
        }

       
    }
    
    class func deleteUserCategory(moc: NSManagedObjectContext, category_id: NSNumber) -> Bool {
        
        let moc : NSManagedObjectContext = moc
        let cu = CoreUser.currentUser(moc)
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CoreUserCategories")
        var coreUserCategories : [CoreUserCategories] = [CoreUserCategories]()
        
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [CoreUserCategories] {
            coreUserCategories = fetchResults
        }
        
        for uc in coreUserCategories {
            if uc.category_id == category_id {
                moc.deleteObject(uc)
                println("\(CoreUserCategories.retrieveUserCategories(moc).count)")
                if moc.save(nil) {
                    return true
                } else {
                    return false
                }
            }
        }
        
        return false
    }

}























