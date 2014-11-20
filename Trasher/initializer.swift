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
    var initialCategories: [Int:String] = [Int:String]()
    var defaulCategories: [Int:String] = [Int:String]()
    
    init() {
        
        println("initializing test data")
        
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
        
        initialCategories = [
            1 : "Clothes",
            2 : "Indoor Furniture",
            6 : "Alcohol Bottles",
            7 : "Electronics",           
        ]
        

        
        var trash = Trash()
        trash.desc = "Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "Used TV"

        trash.addressLine1 = "1408 Baintree place"
        trash.city = "Ottawa"
        trash.postalCode = "K1B5H5"
        trash.latitude = 45.434363
        trash.longitude = -75.560305
        var imageData = NSData(contentsOfFile: "used-tv")
        trash.image = UIImageJPEGRepresentation(UIImage(named: "used-tv"), 0.75)
//        trashArray.addObject(trash)
        trashArray.append(trash)
        
        trash = Trash()

        trash.desc = "Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "old car still good"
        trash.addressLine1 = "934 torovin private1"
        trash.city = "Ottawa1"
        trash.postalCode = "K1B0A5"
        trash.image = UIImageJPEGRepresentation(UIImage(named: "used-tv"), 0.75)
        trash.latitude = 45.438186
        trash.longitude = -75.595628
        
        trashArray.append(trash)
        
        trash = Trash()
        
        trash.desc = "Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "Old crib needs to go"
        trash.addressLine1 = "934 torovin private"
        trash.city = "Ottawa"
        trash.postalCode = "K1B0A4"
        trash.latitude = 45.415416
        trash.image = UIImageJPEGRepresentation(UIImage(named: "used-bbq"), 0.75)
        trash.longitude = -75.606957
        
        trashArray.append(trash)
        
        trash = Trash()
        
        trash.desc = "Trash description trash descriptions Trash description trash descriptions Trash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptionsTrash description trash descriptions"
        trash.title = "TV has to go"
        trash.addressLine1 = "934 torovin private"
        trash.city = "Ottawa"
        trash.postalCode = "K1B0A6"
        trash.image = UIImageJPEGRepresentation(UIImage(named: "used-crib"), 0.75)
        trash.latitude = 45.430959
        trash.longitude = -75.557347
        trashArray.append(trash)
        
        println("Inital data count is: \(trashArray.count)")
        
    }
}
