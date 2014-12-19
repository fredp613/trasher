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
    
    //to do save default categories in core data - here you may want to reconcile with web server every load (in gcd)
    class func generateCategories(managedObjectContext: NSManagedObjectContext) -> [CoreCategories] {
        
        let moc : NSManagedObjectContext = managedObjectContext
        var categoriesArray : [CoreCategories] = [CoreCategories]()
        
        if deleteExistingCategories(moc) {
            
            //here go to web server and fetch latest categories (to do)
            var defaulCategories = [
                1 : "Clothes",
                2 : "Indoor Furniture",
                3 : "Outdoor Furniture",
                4 : "Cooking Supplies",
                5 : "Tools",
                6 : "Alcohol Bottles",
                7 : "Electronics",
                8 : "Wood",
                9 : "Toys",
                10 : "Vehicle"
            ]

            for cat in defaulCategories {
                
                 let coreCat : CoreCategories = NSEntityDescription.insertNewObjectForEntityForName("CoreCategories", inManagedObjectContext: moc) as CoreCategories
                
                 coreCat.id = cat.0
                 coreCat.category_name = cat.1
                 categoriesArray.append(coreCat)
            }
            
            moc.save(nil)
        
        }
        return categoriesArray
        
    }
    
    
    class func retrieveCategories(managedObjectContext: NSManagedObjectContext) -> [CoreCategories] {
    
        let moc : NSManagedObjectContext = managedObjectContext
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CoreCategories")
        var coreCategories = [CoreCategories]()
        
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [CoreCategories] {
            coreCategories = fetchResults
        }
        
        return coreCategories
    
    }
    
    class func deleteExistingCategories(managedObjectContext: NSManagedObjectContext) -> Bool {
        
        let moc : NSManagedObjectContext = managedObjectContext
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CoreCategories")
        var coreCategories = [CoreCategories]()
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [CoreCategories] {
            coreCategories = fetchResults
        }
        
        for cc in coreCategories {
            moc.deleteObject(cc)
            
        }
        if moc.save(nil) {
            return true
        } else {
            return false
        }
        
    }
    
    class func findCategoryById(moc: NSManagedObjectContext, id: NSNumber) -> CoreCategories {
        
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CoreCategories")
        var coreCategories = [CoreCategories]()
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [CoreCategories] {
            
            coreCategories = fetchResults
        }
        
        for cc in coreCategories {
            if cc.id == id {
                return cc
            }
        }
        
        return coreCategories[0]
    }
    
//    ccUserCat.category = CoreCategories.findCategoryById(moc, id: category_id)

}





















