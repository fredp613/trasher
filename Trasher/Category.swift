//
//  Category.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-12.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit

class Category {
    
    var category: String!
    var categoryId: NSNumber!
    var category_user: User!
    var category_trashes: Trash!
    
    init() {
        
    }
    
    func getCategoryName(categoryId: Int!) -> String {
        var defaulCategories = [
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
        
        return defaulCategories[categoryId]!

    }
    
   
    
}