//
//  Contact.swift
//  mapSearch
//
//  Created by Jakub Slawecki on 02/11/2019.
//  Copyright © 2019 Jakub Slawecki. All rights reserved.
//

import Foundation

struct Contact: Codable, Equatable {
    
    var company: String
    var name: String
    var mobile: String
    var mail: String
    
    init(company: String = "Company",
         name: String = "Name",
         mobile: String = "Mobile",
         mail: String = "Mail") {
        
        self.company = company
        self.name = name
        self.mobile = mobile
        self.mail = mail
    }

}
