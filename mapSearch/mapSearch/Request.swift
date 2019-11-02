//
//  Request.swift
//  mapSearch
//
//  Created by Jakub Slawecki on 02/11/2019.
//  Copyright © 2019 Jakub Slawecki. All rights reserved.
//
import Foundation

struct Ticket: Codable, Equatable {
    let id: String
    var ticketId: Int?
    let initialTicketCreation: Date
    var keycloakId: String

    var country: Country
    var userCostCenter: String
    var duration: Int
    var engineers: Int
    var startDate: Date

    var contact: Contact?
    var address: Address
    var location: Location

    var locale: String
    

    init(id: String = UUID().uuidString,
         ticketId: Int? = nil,
         initialTicketCreation: Date = Date(),
         keycloakId: String = "",
         country: Country = Country(),
         userCostCenter: String = "",
         duration: Int = 14400,
         engineers: Int = 1,
         startDate: Date = Date(),
         contact: Contact? = Contact(),
         address: Address = Address(),
         location: Location = Location(),
         locale: String = "") {

        self.id = id
        self.initialTicketCreation = initialTicketCreation
        self.keycloakId = keycloakId
        self.country = country
        self.userCostCenter = userCostCenter
        self.duration = duration
        self.engineers = engineers
        self.startDate = startDate
        self.contact = contact
        self.address = address
        self.location = location
        self.locale = locale
    }

}
