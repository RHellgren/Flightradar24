//
//  FlightsLoaderServiceMock.swift
//  FR24ChallengeTests
//
//  Created by Robin Hellgren on 23/03/2024.
//

import API
import Foundation

final class FlightsLoaderServiceMock: FlightsLoaderService {
    init(session: URLSession) { }
    
    // Fetch
    
    var fetchCallsCount = 0
    var fetchReturnValue: Flights = .mock()
    func fetch() async throws -> Flights {
        fetchCallsCount += 1
        return fetchReturnValue
    }
}
