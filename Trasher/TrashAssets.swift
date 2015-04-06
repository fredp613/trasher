//
//  TrashAssets.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-24.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TrashAssets {
    var trashImage : NSData!
    var trashId : String!
    var defaultImage : Bool!
    
    init() {
        
    }
    
    init(img: NSData, trashId: String, defaultImg: Bool ) {
        self.trashImage = img
        self.trashId = trashId
        self.defaultImage = defaultImg
    }
    
    class func getMainTrashImage(trashAssetArray: [TrashAssets] ,trashId: String) -> NSData {
        
        var trashAssets = trashAssetArray
        var trashArray = InitializeTestData().trashArray
        
        for ta in trashAssets {
            if trashId == ta.trashId {

                if ta.defaultImage.boolValue == true {

                    return ta.trashImage
                }
            }

        }
        return UIImageJPEGRepresentation(UIImage(named: "trash-can-icon"), 0.75)
    }
    
    class func getThumbnail(trashAssetsArray: [TrashAssets], trashId: String) -> NSData? {
        
        var mainImage = trashAssetsArray.filter({ m in
            m.trashId == trashId
        })
        
        if mainImage.count > 0 {
            return mainImage[0].trashImage
        }
        return nil
    }
    
    class func getTrashImagesByIdFromAPI(moc: NSManagedObjectContext, trashId: String, completionHandler: (([TrashAssets]!, NSError!) -> Void)!) -> Void {
       var trashAssets : [TrashAssets] = [TrashAssets]()
        let url = "http://trasher.herokuapp.com/trash_images?trash_id=" + trashId
        println(url)
        TrasherAPI.APIPublicRequest(moc, httpMethod: httpMethodEnum.GET, params: nil, url: url) { (responseObject, error) -> () in
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
                return completionHandler(nil, error)
            } else {
             println(trashAssets.count)
                
             return completionHandler(trashAssets, nil)
           }
       }
        
   }
    
    
    
}
