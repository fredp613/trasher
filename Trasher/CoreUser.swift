//
//  CoreUser.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-20.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData


class CoreUser: NSManagedObject {

    @NSManaged var email: String
    @NSManaged var id: NSNumber
    @NSManaged var tutorial_complete: NSNumber
    @NSManaged var username: String
    @NSManaged var verified: NSNumber
    @NSManaged var remember: NSNumber
    @NSManaged var categories: NSSet
    @NSManaged var locations: NSSet
    
    
    class func createInManagedObjectContext(managedObjectContext: NSManagedObjectContext, coreUser: CoreUser) -> CoreUser {
        
        
        let coreUser = NSEntityDescription.insertNewObjectForEntityForName("CoreUser", inManagedObjectContext: managedObjectContext) as CoreUser
        
        coreUser.verified = true
        coreUser.remember = true
        
        println("core user saved")
        managedObjectContext.save(nil)


        
        return coreUser
    }
    
    class func updateUser(managedObjectContext: NSManagedObjectContext, coreUser: CoreUser) {
        managedObjectContext.save(nil)
    }
    
    class func fetchUserData(managedObjectContext: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "CoreUser")
        var coreUser : CoreUser
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [CoreUser] {
            if !fetchResults.isEmpty {
                coreUser = fetchResults[0]
                let rememberable = coreUser.remember.boolValue
                let verified = coreUser.verified.boolValue
                if rememberable && verified {
                    return true

                }
            }
        }
        
        return false

    }
    
    class func userIsRegistered() -> Bool {
//        if self.fetchUserData(CoreDataStack().managedObjectContext!) {
//            return true
//        }
//            
//        return false
        let managedObjectContext = CoreDataStack().managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "CoreUser")
        var coreUser = [CoreUser]()
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [CoreUser] {
            return true
        }
        return false

    }
    
    class func userIsLoggedIn(managedObjectContext: NSManagedObjectContext) -> Bool {
        

        var user = CoreUser.currentUser(managedObjectContext)
        if user.remember == 1  {
          return true
        }
        
        return false

        
    }
    
    class func deleteAllUserData(managedObjectContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: "CoreUser")
        var coreUser = [CoreUser]()
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [CoreUser] {
            coreUser = fetchResults

        }
        
        for cu in coreUser {
            managedObjectContext.deleteObject(cu)
        }
        managedObjectContext.save(nil)
        
        
    }
    
    class func currentUser(managedObjectContext: NSManagedObjectContext) -> CoreUser {
//        let moc = CoreDataStack().managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "CoreUser")
        var coreUser = [CoreUser]()
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [CoreUser] {
            coreUser = fetchResults
            
        }
        return coreUser[0]
    }
    
    class func authenticated(email: String, password: String) -> Bool {
        let managedObjectContext = CoreDataStack().managedObjectContext!
        let cu = CoreUser.currentUser(managedObjectContext)
        
        if cu.email == email && password == "test" {
            cu.remember = true
            managedObjectContext.save(nil)
            return true
        }
        
        return false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}


