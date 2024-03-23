//
//  FlightsLoader.swift
//  FR24Challenge
//

import Foundation

final class FlightsLoader {

    func loadFlights(completion: @escaping ([String]) -> Void) {
        // TODO: actually load flights
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            completion(Array.init(repeating: "dummy", count: 10))
        }
    }
}
