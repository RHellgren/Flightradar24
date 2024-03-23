//
//  Flights.swift
//  API
//
//  Created by Robin Hellgren on 23/03/2024.
//

import Foundation

struct Flights: Codable {
    let count: Int
    let version: Int
    let copyright: String
    let aircraft: [Aircraft]
    
    enum CodingKeys: String, CodingKey {
        case count = "full_count"
        case version
        case copyright
        case aircraft
    }
}

struct Aircraft: Codable {
    let flightId: String
    let aircraftId: String
    let latitude: Double
    let longitude: Double
    let track: Int
    let altitude: Int
    let speed: Int
    let squawk: String
    let radarName: String
    let aircraftModel: String
    let aircraftRegistration: String
    let timestamp: Int
    let fromIata: String
    let toIata: String
    let flightNumber: String
    let onGround: Int
    let verticalSpeed: Int
    let callsign: String
    
    enum CodingKeys: String, CodingKey {
        case flightId = "flight_id"
        case aircraftId = "aircraft_id"
        case latitude
        case longitude
        case track
        case altitude
        case speed
        case squawk
        case radarName = "radar_name"
        case aircraftModel = "aircraft_model"
        case aircraftRegistration = "aircraft_registration"
        case timestamp
        case fromIata = "from_iata"
        case toIata = "to_iata"
        case flightNumber = "flight_number"
        case onGround = "on_ground"
        case verticalSpeed = "vertical_speed"
        case callsign
    }
}
