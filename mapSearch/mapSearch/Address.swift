//
//  Address.swift
//  mapSearch
//
//  Created by Jakub Slawecki on 02/11/2019.
//  Copyright © 2019 Jakub Slawecki. All rights reserved.
//

import Foundation

struct Address: Codable, Equatable {
    
    var street: String
    var number: String
    var city: String
    var zip: String
    var state: String
    var countryCode: String
    
    init(street: String = "",
         number: String = "",
         city: String = "",
         zip: String = "",
         state: String = "",
         countryCode: String = "") {
        
        self.street = street
        self.number = number
        self.city = city
        self.zip = zip
        self.state = state
        self.countryCode = countryCode
    }

}

