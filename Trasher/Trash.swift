//
//  Trash.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-12.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit
import CoreData


enum TrashType: Int {
    case requested = 1
    case wanted = 2
}

class Trash : Address {
    
    var trashId: String!
    var desc: String!
    var image: NSData!
    var title: String!
    var trash_category: Int!
    var trashArray = [Trash]()
    var trashType : Int!
    var updatedOn : NSDate!
    var createdOn : NSDate!
    var createdBy : Int!
    
    override init() {
        super.init()
        self.trashId = NSUUID().UUIDString
        self.desc = "No description provided"
        self.title = "No description provided"
        self.trashType = TrashType.requested.rawValue
    }
    
    class func categoryName(trash_category: Int!) -> String {
        var cname = Category().getCategoryName(trash_category)
        return cname
    }
    
    class func getTrashFromAPI(moc: NSManagedObjectContext, url: String, completionHandler: (([Trash]!, NSError!) -> Void)!) -> Void {
        var tArray : [Trash] = [Trash]()
        
        TrasherAPI.APIPublicRequest(moc, httpMethod: httpMethodEnum.GET, params: nil, url: url) { (responseObject, error) -> () in
            let json = responseObject
            for (key: String, t: JSON) in json {
                var trash = Trash()
                trash.trashId = t["id"].stringValue
                trash.title = t["title"].stringValue
                trash.desc = t["description"].stringValue
                trash.trash_category = t["catetory_id"].stringValue.toInt()
                trash.addressLine1 = "934 torovin private"
                trash.city = "Ottawa"
                trash.postalCode = "K1B0A4"
                trash.latitude = 45.415416
                trash.longitude = -75.606957
                if let imageUrl = NSURL(string: t["first_image"]["trash_image"]["main"]["url"].stringValue) {
                    if let imageData = NSData(contentsOfURL: imageUrl) {
                        trash.image = UIImageJPEGRepresentation(UIImage(data: imageData), 0.75)
                    }
                }
                if t["trash_type"] == true {
                    trash.trashType = TrashType.requested.rawValue
                } else {
                    trash.trashType = TrashType.wanted.rawValue
                }
                tArray.append(trash)
            }
            
            if (error != nil) {
                return completionHandler(nil, error)
            } else {
                return completionHandler(tArray, nil)
            }
        }
    }
    
    class func getAuthenticatedTrashFromAPI(moc: NSManagedObjectContext, url: String, completionHandler: (([Trash]!, NSError!) -> Void)!) -> Void {
        var tArray : [Trash] = [Trash]()
                
        TrasherAPI.APIAuthenticatedRequest(moc, httpMethod: httpMethodEnum.GET, url: url, params: nil) { (responseObject, error) -> () in
            let json = responseObject
            for (key: String, t: JSON) in json {
                var trash = Trash()
                trash.trashId = t["id"].stringValue
                trash.title = t["title"].stringValue
                trash.desc = t["description"].stringValue
                trash.trash_category = t["catetory_id"].stringValue.toInt()
                trash.addressLine1 = "934 torovin private"
                trash.city = "Ottawa"
                trash.postalCode = "K1B0A4"
                trash.latitude = 45.415416
                trash.longitude = -75.606957
                if let imageUrl = NSURL(string: t["first_image"]["trash_image"]["main"]["url"].stringValue) {
                    if let imageData = NSData(contentsOfURL: imageUrl) {
                        trash.image = UIImageJPEGRepresentation(UIImage(data: imageData), 0.75)
                    }
                }
                if t["trash_type"] == true {
                    trash.trashType = TrashType.requested.rawValue
                } else {
                    trash.trashType = TrashType.wanted.rawValue
                }
                tArray.append(trash)
            }
            
            if (error != nil) {
                return completionHandler(nil, error)
            } else {
                return completionHandler(tArray, nil)
            }
        }
        
    }
    
    class func updateTrashFromAPI(moc: NSManagedObjectContext, url: String, trash_id: String, params: [String : AnyObject], pickedAssets: [UIImage]?, completionHandler: ((Bool, NSError!) -> Void)!) -> Void {
        var tArray : [Trash] = [Trash]()
            
        TrasherAPI.APIAuthenticatedRequest(moc, httpMethod: httpMethodEnum.PATCH, url: APIUrls.update_trash + trash_id, params: params) { (responseObject, error) -> () in
            if error == nil {
               return completionHandler(true, nil)
            } else {
               return completionHandler(false, error)
            }
            
        }
        
        if pickedAssets?.count > 0 {
            //create images
        }
    
    }

    
    class func filterTrash(arrayOfTrash: [Trash]) -> [Trash] {
        
        let filterTrash = arrayOfTrash.filter({ (trash: Trash) -> Bool in
            return trash.trashType == 1
        }) as [Trash]
        
        return filterTrash
    }
    
    class func filterWantedTrash(arrayOfTrash: [Trash]) -> [Trash] {
        
        let filterWantedTrash = arrayOfTrash.filter({ (trash: Trash) -> Bool in
            return trash.trashType == 2
        }) as [Trash]
        
        return filterWantedTrash
    }
}
    

    
    
    
