//
//  Trash.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-12.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit

class Trash : Address {
    
    var desc: String!
    var image: NSData!
    var title: String!
    var trash_category: Category!
    var trashArray = [Trash]()
    
    override init() {
        desc = "First description"
        image = UIImageJPEGRepresentation(UIImage(named: "used-bbq"), 0.75)
        title = "First title"
        super.init()
    }
    
    
    
}