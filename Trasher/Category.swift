//
//  Category.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-28.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit

class Category  {
    
    var category: String
    var initials1: [Int:String]
    var defaults: [Int:String]
    
    
    
    
    init() {
        category = ""
        initials1 = [
            4: "Vehicle",
            5: "Clothes",
            6: "Toys",
            7: "Indoor furniture"
        ]
        defaults = [
            1: "Household appliances",
            2: "Outdoor furniture",
            3: "Scrap",
            4: "Vehicle",
            5: "Clothes",
            6: "Toys",
            7: "Indoor furniture"
        
        ]
        
    }
    
    init(category: String) {
        self.category = category
        self.initials1 = [
            1: "Vehicle",
            2: "Clothes",
            3: "Toys",
            4: "Indoor furniture"
        ]
        self.defaults = [
            1: "Household appliances",
            2: "Outdoor furniture",
            3: "Scrap",
            4: "Vehicle",
            5: "Clothes",
            6: "Toys",
            7: "Indoor furniture"
            
        ]
    }
    
   
    
    
    
 
    
    
    class func defaultCategories() -> NSMutableArray {
    
        var categoriesArray = NSMutableArray()
        
        var cat = Category(category: "Household appliances")
        categoriesArray.addObject(cat)
        
        cat = Category(category: "Outdoor furniture")
        categoriesArray.addObject(cat)
        cat = Category(category: "Indoor furniture")
        categoriesArray.addObject(cat)
        cat = Category(category: "Scrap")
        categoriesArray.addObject(cat)
        cat = Category(category: "Vehical")
        categoriesArray.addObject(cat)
        cat = Category(category: "Toys")
        categoriesArray.addObject(cat)
        cat = Category(category: "Clothes - Adult")
        categoriesArray.addObject(cat)
        cat = Category(category: "Clothes - Children")
        categoriesArray.addObject(cat)
        cat = Category(category: "Clothes - Baby")
        categoriesArray.addObject(cat)
        cat = Category(category: "Children furniture")
        categoriesArray.addObject(cat)
        
        return categoriesArray
        
    }
    
    class func initialCategories() -> NSMutableArray {
        var categoriesArray = NSMutableArray()
        
        var cat = Category(category: "Household appliances")
        categoriesArray.addObject(cat)
        cat = Category(category: "Outdoor furniture")
        categoriesArray.addObject(cat)
        cat = Category(category: "Indoor furniture")
        categoriesArray.addObject(cat)
        cat = Category(category: "Scrap")
        categoriesArray.addObject(cat)
        
        return categoriesArray

    }
    
}
