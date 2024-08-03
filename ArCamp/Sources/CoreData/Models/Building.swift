//
//  Building.swift
//  ArCamp
//
//  Created by Mantas Ercius on 11.07.24.
//

import Foundation

struct Building: Identifiable, Codable {
    let id: String
    let name: String
    let campus: String
    let address: String
    let enterances: [Entrance]
    let latitude: Double
    let longitude: Double
    let description: String
    let hours_of_operation: HoursOfOperation
    let facilities: [String]
    let departaments: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, campus, address, enterances, latitude, longitude, description, hours_of_operation, facilities, departaments
    }
}

struct Entrance: Identifiable, Codable {
    let id = UUID()
    let type: String
    let accessible: Bool
    let elivator: Bool
    let latitude: Double
    let longitude: Double
}

struct HoursOfOperation: Codable {
    let monday_to_friday: String
    let saturday: String
}
