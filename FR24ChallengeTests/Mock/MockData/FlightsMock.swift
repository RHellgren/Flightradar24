//
//  FlightsMock.swift
//  FR24ChallengeTests
//
//  Created by Robin Hellgren on 23/03/2024.
//

import API
import Foundation

extension Flights {
    static func mock() -> Flights {
        let mockData = MockData().readJSONFile(fileName: "Flights_mock")
        return try! JSONDecoder().decode(Flights.self, from: mockData)
    }
}
