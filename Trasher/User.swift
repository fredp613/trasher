//
//  User.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-12.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var authType: String!
    var distance: NSNumber!
    var email: String!
    var tutorial_completed: NSNumber!
    var userId: NSNumber!
    var userName: String!
    var verified: NSNumber!
    var notifications: NSNumber!
    var user_addresses: NSSet!
    var user_categories: NSSet!
    
    init() {
      authType = "Twitter"
      distance = 50
      email = "fredp613@gmail.com"
      tutorial_completed = 0
      userId = 1
      userName = "fredp613"
      verified = 0
      notifications = 1
      
      
        
    }
       
}