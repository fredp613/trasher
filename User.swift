//
//  User.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-10.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData

class User {

     var authType: String
     var distance: Int
     var email: String
     var userId: Int
     var userName: String
    
    init() {
        authType = "Twitter"
        distance = 50
        email = "fredp613@gmail.com"
        userId = 1
        userName = "fredp613"
    }
   

}
