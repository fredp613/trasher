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
    @NSManaged var preferred_distance: NSNumber
    @NSManaged var notifications_on: NSNumber
    @NSManaged var metric: NSNumber
    @NSManaged var created_on: NSDate
    @NSManaged var updated_on: NSDate
    
    
    class func createInManagedObjectContext(managedObjectContext: NSManagedObjectContext, email: String, pwd: String) -> Bool {
        // here you should validate and wrap the code below

        let coreUser : CoreUser = NSEntityDescription.insertNewObjectForEntityForName("CoreUser", inManagedObjectContext: managedObjectContext) as! CoreUser
        
        coreUser.id = NSUUID().UUIDString
        coreUser.email = email
        coreUser.verified = true
        coreUser.remember = true
        coreUser.preferred_distance = 50
        coreUser.notifications_on = true
        coreUser.created_on = NSDate()
        coreUser.updated_on = coreUser.created_on

        println("core user saved")
        if managedObjectContext.save(nil) {
            println("user registration successfull")
            return true
        } else {
          return false
        }
//        return false
    }

    
    class func updateUser(managedObjectContext: NSManagedObjectContext, coreUser: CoreUser) {
        coreUser.updated_on = NSDate()
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
    
    class func userIsRegistered(moc: NSManagedObjectContext) -> Bool {
//        if self.fetchUserData(CoreDataStack().managedObjectContext!) {
//            return true
//        }
//            
//        return false
//        let managedObjectContext = CoreDataStack().managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "CoreUser")
        var coreUser = [CoreUser]()
        let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [CoreUser]
        if fetchResults?.count > 0 {
            return true
        } else {
            return false
        }


    }
    
    class func userIsLoggedIn(managedObjectContext: NSManagedObjectContext) -> Bool {
        
        
        var user = CoreUser.currentUser(managedObjectContext)!
        if user.remember == true  {
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
    
    class func currentUser(managedObjectContext: NSManagedObjectContext) -> CoreUser? {
//        let moc = CoreDataStack().managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "CoreUser")
        var coreUser = [CoreUser]()
        var error : NSError? = nil
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [CoreUser] {
            coreUser = fetchResults
            if fetchResults.count > 0 {
                return coreUser[0]
            }
        } else {
            println("\(error?.userInfo)")
        }
       return nil
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
    
    
//    class func apiAuthenticated(email: String, password: String) -> Bool {
//        let moc = CoreDataStack().managedObjectContext!
//        let cu = CoreUser.currentUser(moc)
//        
//        let retrieveTokenFromKeyChain: String = KeyChainHelper.retrieveTokenForKey("fredp613@gmail.com")
//        
//        
//        return false
//    }
    
    class func authenticated(email: String, password: String, completionHandler: ((Bool!) -> Void)!) -> Void {
        let managedObjectContext = CoreDataStack().managedObjectContext!
        
        let params = [
            "user": ["email" : email,
                "password" : password]
        ]

        var authenticated : Bool = false
        
        if let cu = CoreUser.currentUser(managedObjectContext) {
            //user exists in core data
            TrasherAPI.APIAuthenticatedRequest(managedObjectContext, httpMethod: httpMethodEnum.POST, url: APIUrls.login, params: params, completionHandler: { (data, error) -> () in
                if data != nil {
                    return completionHandler(true)
                } else {
                    return completionHandler(false)
                }

            })
        } else {
            //user doesnt exist in core data
            TrasherAPI.APIPublicRequest(managedObjectContext, httpMethod: httpMethodEnum.POST, params: params, url: APIUrls.login, completionHandler: { (data, error) -> () in

                if data != nil {
                    let json = data
                    CoreUser.createInManagedObjectContext(managedObjectContext, email: email, pwd: password)
                    let token : String = json["user"]["auth_token"].string!
                    KeyChainHelper.createORupdateForKey("fredp613", keyName: email)
                    KeyChainHelper.createORupdateForKey(token, keyName: "auth_token")
                    return completionHandler(true)
                } else {
                    return completionHandler(false)
                }
            })
        }
       
    }
    
    class func getUserToken(user: CoreUser) -> String? {
        if let tokenFromKeychain: String = KeyChainHelper.retrieveForKey("auth_token") {
            return tokenFromKeychain
        }
        
        return nil
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


