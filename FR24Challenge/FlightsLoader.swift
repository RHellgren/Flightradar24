//
//  FlightsLoader.swift
//  FR24Challenge
//

import API
import Foundation

final class FlightsLoader {
    
    private let service: FlightsLoaderService!
    private var flights: Flights?
    
    init(
        service: FlightsLoaderService = FlightsLoaderServiceImpl()
    ) {
        self.service = service
    }

    func loadFlights(
        completion: @escaping ([String]) -> Void
    ) {
        @Sendable func flightIds() -> [String] {
            flights?.aircraft.map { $0.flightId } ?? []
        }
        
        guard flights == nil else {
            completion(flightIds())
            return
        }
        
        Task {
            let flights = try await service.fetch()
            self.flights = flights
            completion(flightIds())
        }
    }
    
    func loadIATAs(
        completion: @escaping ((to: [String], from: [String])) -> Void
    ) {
        @Sendable func iatas() -> ([String], [String]) {
            let to = flights?
                .aircraft
                .map { $0.toIATA }
                .unique()
                .sorted()
                .filter({ $0 != "" }) ?? []
            let from = flights?
                .aircraft
                .map { $0.fromIATA }
                .unique()
                .sorted()
                .filter({ $0 != "" }) ?? []
            return (to: to, from: from)
        }
        
        guard flights == nil else {
            completion(iatas())
            return
        }
        
        Task {
            let flights = try await service.fetch()
            self.flights = flights
            completion(iatas())
        }
    }
}
