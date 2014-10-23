//
//  Address.swift
//  Trasher
//
//  Created by Fred Pearson on 2014-10-18.
//  Copyright (c) 2014 Frederick Pearson. All rights reserved.
//

import UIKit

class Address : User  {

    var addressLine1: String
    var addressLine2: String
    var city: String
    var postalCode: String
    var country: String
    var latitude: Double
    var longitude: Double
    
    override init() {

        addressLine1 = "first"
        addressLine2 = "second"
        city = "Ottawa"
        postalCode = "k1b0a5"
        country = "Canada"
        latitude = 20.12
        longitude = 20.12
        super.init()
    }
    
    func fullAddress() -> String {
        return addressLine1 + " " + city + " " +  postalCode
    }
}
