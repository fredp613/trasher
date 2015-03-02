//
//  CoreTrashImage.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-12-29.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData

class CoreTrashImage: NSManagedObject {

    @NSManaged var trash_image: NSData
    @NSManaged var created_on: NSDate
    @NSManaged var updated_on: NSDate
    @NSManaged var trash: CoreTrash
    
    class func saveTrashImage(trashImage: CoreTrashImage, moc: NSManagedObjectContext) -> Bool {
        
        trashImage.created_on = NSDate()
        trashImage.updated_on = trashImage.created_on
        
        var error: NSError? = nil
        saveTrashImage(trashImage, moc: moc)
        if moc.save(&error) {
            return true
        } else {
            println("\(error?.userInfo)")
            return false
        }
    }
    
   
    
    class func fetchAllTrashImages(moc: NSManagedObjectContext) -> [CoreTrashImage] {
        let fetchRequest = NSFetchRequest(entityName: "CoreTrashImage")
        fetchRequest.returnsObjectsAsFaults = false
        var coreTrash = [CoreTrashImage]()
        let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [CoreTrashImage]
        if fetchResults?.count > 0 {
            coreTrash = fetchResults!
        }
        return coreTrash
    }
    
    class func getTrashImages(trash_id: String, moc: NSManagedObjectContext) -> [CoreTrashImage]? {
        let fetchRequest = NSFetchRequest(entityName: "CoreTrashImage")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "trash.id == %@", trash_id)
        fetchRequest.predicate = predicate
        
        var coreTrashImages = [CoreTrashImage]()
        let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [CoreTrashImage]
        if fetchResults?.count > 0 {
            coreTrashImages = fetchResults!
        }
        return coreTrashImages
    }
    
    class func updateTrashImage(moc: NSManagedObjectContext, coreTrashImage: CoreTrashImage) -> Bool {
        coreTrashImage.updated_on = NSDate()
        if moc.save(nil) {
          return true
        }
        return false
        
    }
    
    class func deleteImagesForTrash(moc: NSManagedObjectContext, trash: CoreTrash) {
        let trash_id = trash.id
        
        let fetchRequest = NSFetchRequest(entityName: "CoreTrashImage")
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "trash.id == %@", trash_id)
        fetchRequest.predicate = predicate
        
        var coreTrashImages = [CoreTrashImage]()
        let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [CoreTrashImage]
        if fetchResults?.count > 0 {
            coreTrashImages = fetchResults!
        }
        
        for cti in coreTrashImages {
            moc.deleteObject(cti)
        }
        
    }
    
    
    
    
    
    
    
    
    

}
