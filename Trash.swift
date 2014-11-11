//
//  Trash.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-10.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Trash : Address {
     var desc: String!
     var image: UIImage!
     var title: String!
    
    override init() {
        super.init()
    }
}
