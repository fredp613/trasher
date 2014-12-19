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
    @NSManaged var id: String
    @NSManaged var tutorial_complete: NSNumber
    @NSManaged var username: String
    @NSManaged var verified: NSNumber
    @NSManaged var remember: NSNumber
    @NSManaged var categories: NSSet
    @NSManaged var locations: NSSet
    @NSManaged var trashes: NSSet
    
    
    class func createInManagedObjectContext(managedObjectContext: NSManagedObjectContext, email: String, pwd: String) -> Bool {
        

        let coreUser : CoreUser = NSEntityDescription.insertNewObjectForEntityForName("CoreUser", inManagedObjectContext: managedObjectContext) as CoreUser
        
        coreUser.id = NSUUID().UUIDString
        coreUser.email = email
        coreUser.verified = true
        coreUser.remember = true

        println("core user saved")
        if managedObjectContext.save(nil) {
          let saveSuccessful: Bool = KeyChainHelper.createORupdatePasswordForKey(pwd, keyName: email)
           
            if saveSuccessful {
                println("successful")
//                CoreCategories.generateCategories(managedObjectContext)
                CoreUserCategories.generateDefaultCategoriesForNewUser(managedObjectContext, currentUser: coreUser)
                return true
            } else {
                managedObjectContext.rollback()
                println("unsuccessful")
                return false
            }

        } else {
          return false
        }

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
        let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [CoreUser]
        if fetchResults?.count > 0 {
            return true
        } else {
            return false
        }


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
    
    class func userExists(managedObjectContext: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "CoreUser")
        var coreUser = [CoreUser]()
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [CoreUser] {
            coreUser = fetchResults
        }
        if coreUser.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    
    
    class func authenticated(email: String, password: String) -> Bool {
        let managedObjectContext = CoreDataStack().managedObjectContext!
        let cu = CoreUser.currentUser(managedObjectContext)
        
        
        let retrievePwdFromKeychain: String = KeyChainHelper.retrievePasswordForKey("fredp613@gmail.com")
        
        if cu.email == email && (password == retrievePwdFromKeychain) {
            cu.remember = true
            managedObjectContext.save(nil)
            return true
        }
        
        return false
    }
    
    class func fetchUser(managedObjectContext: NSManagedObjectContext) -> Int {
        let moc : NSManagedObjectContext = managedObjectContext
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CoreUser")
        var coreUser = [CoreUser]()
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [CoreUser] {
            coreUser = fetchResults
        }
        
        return coreUser.count
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}


