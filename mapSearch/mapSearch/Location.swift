//
//  Location.swift
//  mapSearch
//
//  Created by Jakub Slawecki on 02/11/2019.
//  Copyright © 2019 Jakub Slawecki. All rights reserved.
//

import Foundation

struct Location: Codable, Equatable {
    
    var latitude: Double
    var longitude: Double
    var timeZoneId: String
    
    init(latitude: Double = 0.00000,
         longitude: Double = 0.00000,
         timeZoneId: String = "Europe/Berlin") {
        
        self.latitude = latitude
        self.longitude = longitude
        self.timeZoneId = timeZoneId
    }
}
