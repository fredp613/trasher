//
//  Trash.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-18.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit

class Trash : Address {
    
    var desc: String!
    var title: String!
    var image: UIImage!
    
    override init() {
        desc = "No description provided"
        title = "No title provided"
        image = UIImage(named: "trash-can-icon")
        super.init()
    }
    
}
