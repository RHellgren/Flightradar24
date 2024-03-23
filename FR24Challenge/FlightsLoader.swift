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
    
    func calculateRoute(
        from: String?,
        to: String?
    ) -> [Aircraft]? {
        guard let from, let to, to != from, let flights else {
            return nil
        }
        
        // Check direct flights
        if let direct = flights.aircraft.first(
            where: { $0.fromIATA == from && $0.toIATA == to }
        ) {
            return [direct]
        }
        
        // Check one stop
        let relevantFirstFlights = flights.aircraft.filter({ $0.fromIATA == from })
        for flight in relevantFirstFlights {
            if let layover = flights.aircraft.first(
                where: { $0.fromIATA == flight.toIATA && $0.toIATA == to }
            ) {
                return [flight, layover]
            }
        }
        
        // No flight match could be found
        return nil
    }
}
