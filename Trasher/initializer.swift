//
//  initializer.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-10.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class InitializeTestData {
    
    var trashArray = [Trash]()
    var trashAssets = [TrashAssets]()
    var initialCategories: [Int:String] = [Int:String]()
    var defaulCategories: [Int:String] = [Int:String]()
    var filterRequestedTrash = [Trash]()
    var filterWantedTrash = [Trash]()
    var filteredTrash = [Trash]()
   
    
    init() {
                       
    }
    
    func generateDefaultCategories() -> [Int:String] {
        defaulCategories = [
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
        
        return defaulCategories
    }
    
    func generateInitialCategories() -> [Int:String] {
        initialCategories = [
            1 : "Clothes",
            2 : "Indoor Furniture",
            6 : "Alcohol Bottles",
            7 : "Electronics",
        ]
        
        return initialCategories
    }
    

    
    func generateTestData() -> [Trash] {
        defaulCategories = self.generateDefaultCategories()
        
        
        initialCategories = self.generateInitialCategories()
        
        
        var trash = Trash()
        trash.trashId = NSUUID().UUIDString
        trash.desc = "Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "Used TV"
        trash.addressLine1 = "1408 Baintree place"
        trash.city = "Ottawa"
        trash.postalCode = "K1B5H5"
        trash.latitude = 45.434363
        trash.longitude = -75.560305
        trash.trash_category = 1
        
        var imageData = NSData(contentsOfFile: "used-tv")
        trash.image = UIImageJPEGRepresentation(UIImage(named: "used-tv"), 0.75)
        //        trashArray.addObject(trash)
        trashArray.append(trash)
        
        trash = Trash()
        trash.trashId = NSUUID().UUIDString
        trash.desc = "Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "old car still good"
        trash.addressLine1 = "934 torovin private1"
        trash.city = "Ottawa1"
        trash.postalCode = "K1B0A5"
        trash.image = UIImageJPEGRepresentation(UIImage(named: "used-tv"), 0.75)
        trash.latitude = 45.438186
        trash.longitude = -75.595628
        trash.trash_category = 4
        
        trashArray.append(trash)
        
        trash = Trash()
        trash.trashId = NSUUID().UUIDString
        trash.desc = "Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "Old crib needs to go"
        trash.addressLine1 = "934 torovin private"
        trash.city = "Ottawa"
        trash.postalCode = "K1B0A4"
        trash.latitude = 45.415416
        trash.image = UIImageJPEGRepresentation(UIImage(named: "used-bbq"), 0.75)
        trash.longitude = -75.606957
        trash.trash_category = 5
        
        trashArray.append(trash)
        
        trash = Trash()
        trash.trashId = NSUUID().UUIDString
        trash.desc = "Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "TV has to go"
        trash.addressLine1 = "934 torovin private"
        trash.city = "Ottawa"
        trash.postalCode = "K1B0A6"
        trash.image = UIImageJPEGRepresentation(UIImage(named: "used-crib"), 0.75)
        trash.latitude = 45.430959
        trash.longitude = -75.557347
        trashArray.append(trash)
        trash.trash_category = 2
        
        
        trash = Trash()
        trash.trashId = NSUUID().UUIDString
        trash.desc = "WANTED Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "Old crib needs to go"
        trash.addressLine1 = "934 torovin private"
        trash.city = "Ottawa"
        trash.postalCode = "K1B0A4"
        trash.latitude = 45.415416
        trash.longitude = -75.606957
        trash.trashType = TrashType.wanted.rawValue
        trash.trash_category = 7
        trash.image = UIImageJPEGRepresentation(UIImage(named: "used-crib"), 0.75)
        trashArray.append(trash)
        
        trash = Trash()
        trash.trashId = NSUUID().UUIDString
        trash.desc = "WANTED used crib Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "Sold crib needs to go"
        trash.addressLine1 = "934 torovin private"
        trash.city = "Ottawa"
        trash.postalCode = "K1B0A4"
        trash.latitude = 45.415416
        trash.longitude = -75.606957
        trash.trashType = TrashType.wanted.rawValue
        trash.trash_category = 3
        trash.image = UIImageJPEGRepresentation(UIImage(named: "used-crib"), 0.75)
        trashArray.append(trash)
        
        
        return trashArray
    }
    
    func generateFilteredTrashAssets() -> [TrashAssets] {
        var trashArray = self.trashArray
        
        var images : [NSData] = [
            UIImageJPEGRepresentation(UIImage(named: "used-tv"), 0.75),
            UIImageJPEGRepresentation(UIImage(named: "used-bbq"), 0.75),
            UIImageJPEGRepresentation(UIImage(named: "used-crib"), 0.75),
            UIImageJPEGRepresentation(UIImage(named: "trash-can-icon"), 0.75)
        ]
        
        var trashImage = TrashAssets(img: images[0], trashId: trashArray[0].trashId, defaultImg: false)
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[1], trashId: trashArray[0].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[3], trashId: trashArray[0].trashId,defaultImg: true )
        trashAssets.append(trashImage)
        
        trashImage = TrashAssets(img: images[1], trashId: trashArray[1].trashId,defaultImg: true )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[3], trashId: trashArray[1].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[2], trashId: trashArray[1].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        
        trashImage = TrashAssets(img: images[0], trashId: trashArray[2].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[2], trashId: trashArray[2].trashId,defaultImg: true )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[1], trashId: trashArray[2].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[3], trashId: trashArray[2].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        
        trashImage = TrashAssets(img: images[2], trashId: trashArray[3].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[1], trashId: trashArray[3].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[0], trashId: trashArray[3].trashId,defaultImg: true )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[3], trashId: trashArray[3].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        
        trashImage = TrashAssets(img: images[2], trashId: trashArray[4].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[1], trashId: trashArray[4].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[0], trashId: trashArray[4].trashId,defaultImg: true )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[3], trashId: trashArray[4].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        
        trashImage = TrashAssets(img: images[2], trashId: trashArray[5].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[1], trashId: trashArray[5].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[0], trashId: trashArray[5].trashId,defaultImg: true )
        trashAssets.append(trashImage)
        trashImage = TrashAssets(img: images[3], trashId: trashArray[5].trashId,defaultImg: false )
        trashAssets.append(trashImage)
        
        return trashAssets
    }
    
    func filterRequestedTrash(arrayOfTrash: [Trash]) -> [Trash] {
        
        filterRequestedTrash = arrayOfTrash.filter({ (trash: Trash) -> Bool in
            return trash.trashType == 1
        })
        println(filterRequestedTrash)
        return filterRequestedTrash
   
    }
    
    func filterWantedTrash(arrayOfTrash: [Trash]) -> [Trash] {
        
        filterWantedTrash = arrayOfTrash.filter({ (trash: Trash) -> Bool in
            return trash.trashType == 2
        })
        println(filterWantedTrash)
        return filterWantedTrash
    }
    
   
    
    
}
