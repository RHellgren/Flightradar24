//
//  FlightsLoader.swift
//  FR24Challenge
//

import API
import Foundation

final class FlightsLoader {
    
    private let service: FlightsLoaderService!
    
    init(
        service: FlightsLoaderService = FlightsLoaderServiceImpl()
    ) {
        self.service = service
    }

    func loadFlights(
        completion: @escaping ([String]) -> Void
    ) {
        Task {
            let flights = try await service.fetch()
            let flightIds = flights.aircraft.map { $0.flightId }
            completion(flightIds)
        }
    }
}
