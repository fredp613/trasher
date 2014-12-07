//
//  Trash.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-12.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit

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
        trashId = NSUUID().UUIDString
        desc = "First description"
        image = UIImageJPEGRepresentation(UIImage(named: "trash-can-icon"), 0.75)
        title = "First title"
        trashType = TrashType.requested.rawValue
        super.init()
    }
    
    func categoryName(trash_category: Int!) -> String {
        
        var cname = Category().getCategoryName(trash_category)
        
        return cname
    }
    
    
    
}