//
//  Address.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-12.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import UIKit

class Address : User {
    
    var addressId: NSNumber!
    var addressLine1: String!
    var addressLine2: String!
    var city: String!
    var country: String!
    var latitude: NSNumber!
    var longitude: NSNumber!
    var postalCode: String!
    var address_user: User!
    var address_trash: Trash!
    
    override init() {
     addressId = 1
     addressLine1 = "1408 Baintree place"
     addressLine2 = ""
     city = "Ottawa"
     country = "Canada"
     latitude = 2.0
     longitude = 3.0
     postalCode = "k1b0a5"
     super.init()
        
    }
    
    func fullAddress() -> String {
        return addressLine1 + " " + addressLine2 + " " + city + " " + postalCode
    }

    
}