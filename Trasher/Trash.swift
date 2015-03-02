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
    
    override init() {
        super.init()
        self.trashId = NSUUID().UUIDString
        self.desc = "No description provided"
//        self.image = UIImageJPEGRepresentation(UIImage(named: "trash-can-icon"), 0.75)
        self.title = "No description provided"
        self.trashType = TrashType.requested.rawValue
//        self.getTrashImageFromAPI()

        
    }
    
    func categoryName(trash_category: Int!) -> String {
        
        var cname = Category().getCategoryName(trash_category)
        
        return cname
    }
    
    
    class func getTrashFromAPI(moc: NSManagedObjectContext, completionHandler: (([Trash]!, NSError!) -> Void)!) -> Void {
        var tArray : [Trash] = [Trash]()
        
        TrasherAPI.APIAuthenticatedRequest(moc, httpMethod: httpMethodEnum.GET, url: "http://trasher.herokuapp.com/trashes", params: nil) { (responseObject, error) -> () in
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
                trash.image = UIImageJPEGRepresentation(UIImage(named: "used-crib"), 0.75)
                
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
    
    class func getTrashImageFromAPI1(moc: NSManagedObjectContext, completionHandler: (([TrashAssets]!, NSError!) -> Void)!) -> Void {
        var trashAssets : [TrashAssets] = [TrashAssets]()
        
        TrasherAPI.APIAuthenticatedRequest(moc, httpMethod: httpMethodEnum.GET, url: "http://trasher.herokuapp.com/trash_images", params: nil) { (responseObject, error) -> () in
            let json = responseObject
            var trashImage = TrashAssets()
            for (key: String, t: JSON) in json {
                trashImage = TrashAssets()
                trashImage.trashId = t["trash_id"].stringValue
                let imageUrl = NSURL(string: t["trash_image"]["trash_image"]["main"]["url"].stringValue)
                let imageData = NSData(contentsOfURL: imageUrl!)
                trashImage.trashImage = UIImageJPEGRepresentation(UIImage(data: imageData!), 0.75)
                if key == "0" {
                    trashImage.defaultImage = true
                }
                trashAssets.append(trashImage)
            }
            
            if (error != nil) {
                println(error)
                return completionHandler(nil, error)
            } else {
                return completionHandler(trashAssets, nil)
            }
        }
        
    }
           
    
    class func getTrashImageFromAPI(completionHandler: (([TrashAssets]!, NSError!) -> Void)!) -> Void {
        
        var tAssetsArray : [TrashAssets] = [TrashAssets]()
        
        let urlAsString = "https://trasher.herokuapp.com/trash_images.json"
        let url: NSURL  = NSURL(string: urlAsString)!
        let urlSession = NSURLSession.sharedSession()
        
        let task = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            
            
            var trashAssetsJsonResults = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSArray
            
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            
            //            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var trashImage = TrashAssets()
            for (index, ti) in enumerate(trashAssetsJsonResults!) {
                
                trashImage = TrashAssets()
                let tId = ti["trash_id"] as Int
                trashImage.trashId = String(tId)
                if let t_Image = ti["trash_image"] as? NSDictionary {
                   
                    if let t_Image_level = ti["trash_image"] as? NSDictionary {
                        if let t_Image_level_1 = t_Image_level["trash_image"] as? NSDictionary {
                            if let t_Image_main = t_Image_level_1["main"] as? NSDictionary {
                                if let t_image_url = t_Image_main["url"] as? String{
                                    let imageUrl = NSURL(string: t_image_url)
                                    let imageData = NSData(contentsOfURL: imageUrl!)
                                    trashImage.trashImage = UIImageJPEGRepresentation(UIImage(data: imageData!), 0.75)
                                    tAssetsArray.append(trashImage)                                    
                                }
                            }
                        }
                    }
                   
                    
                }
                
               
            }
            
            if (err != nil) {
                return completionHandler(nil, err)
            } else {
                return completionHandler(tAssetsArray, nil)
            }
            
            
        })

        task.resume()
        
    }
    
    
    
    
//    class func getTrashFromAPI(completionHandler: (([Trash]!, NSError!) -> Void)!) -> Void {
//    
//        
//        
//        
//        var tArray : [Trash] = [Trash]()
//        
//        let urlAsString = "https://trasher.herokuapp.com/trashes.json"
//        let url: NSURL  = NSURL(string: urlAsString)!
//        let urlSession = NSURLSession.sharedSession()
//        
//        let task = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
//            if (error != nil) {
//                println(error.localizedDescription)
//            }
//            var err: NSError?
//            
//            
//            var trashesJsonResults = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSArray
//            
//            if (err != nil) {
//                println("JSON Error \(err!.localizedDescription)")
//            }
//            
//            
//
//                var trash = Trash()
//                for ti in trashesJsonResults! {
//                    trash = Trash()
//                    let tId = ti["id"] as Int
//                    trash.trashId = String(tId)
//                    trash.desc = ti["description"] as? String
//                    trash.title = ti["title"] as? String
//                    trash.addressLine1 = "934 torovin private"
//                    trash.city = "Ottawa"
//                    trash.postalCode = "K1B0A4"
//                    trash.latitude = 45.415416
//                    trash.longitude = -75.606957
//                    var tType : Int?
//                    if let trash_type_from_api = ti["trash_type"] as? Bool {
//                        
//                        if trash_type_from_api {
//                            tType = TrashType.requested.rawValue
//                        } else {
//                            tType = TrashType.wanted.rawValue
//                        }
//                    } else {
//                        tType = TrashType.wanted.rawValue
//                    }
//                    trash.trashType = tType
//                    trash.trash_category = 3
//                    trash.image = UIImageJPEGRepresentation(UIImage(named: "used-crib"), 0.75)
//                    tArray.append(trash)
//
//                }
//
//            
//                if (err != nil) {
//                    return completionHandler(nil, err)
//                } else {
//                    return completionHandler(tArray, nil)
//                }
//            
//            
//
//            
//            })
//
//        task.resume()
//
//        
//    }
    
    func setTrashArray(ta: [Trash]) {
        self.trashArray = ta
    }
    
    class func filterRequestedTrash(arrayOfTrash: [Trash]) -> [Trash] {
        
        let filterRequestedTrash = arrayOfTrash.filter({ (trash: Trash) -> Bool in
            return trash.trashType == 1
        }) as [Trash]
        
        return filterRequestedTrash
        
    }
    
    class func filterWantedTrash(arrayOfTrash: [Trash]) -> [Trash] {
        
        let filterWantedTrash = arrayOfTrash.filter({ (trash: Trash) -> Bool in
            return trash.trashType == 2
        }) as [Trash]
        
        return filterWantedTrash
    }

    
    
    
}
    

    
    
    
