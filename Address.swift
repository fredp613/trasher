//
//  Address.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-11-10.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Address : User {

     var addressId: Int
     var addressLine1: String
     var addressLine2: String
     var city: String
     var country: String
     var latitude: Double
     var longitude: Double
     var postalCode: String
    
    override init() {
        addressId = 1
        addressLine1 = "1408 Baintree Place"
        addressLine2 = ""
        city = "Ottawa"
        country = "Canada"
        latitude = 37.78583400
        longitude = -122.40641700
        postalCode = "k1b0a5"
        super.init()
    }
    
    func fullAddress() -> String {
        var fullAddress = "\(addressLine1 + addressLine2 + city + postalCode)"
        return fullAddress
     }

}
