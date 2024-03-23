//
//  FlightsLoaderService.swift
//  API
//
//  Created by Robin Hellgren on 23/03/2024.
//

import Foundation

public protocol FlightsLoaderService {
    init(session: URLSession)
    func fetch() async throws -> Flights
}

public final class FlightsLoaderServiceImpl: FlightsLoaderService {
    
    private let session: URLSession
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    // MARK: - Initialiser
    
    public init(
        session: URLSession = .shared
    ) {
        self.session = session
    }
    
    // MARK: - Public interface
    
    public func fetch() async throws -> Flights {
        guard let request = createRequest() else {
            throw FlightsLoaderServiceError.urlParsingFailed
        }

        let (data, response) = try await session.data(for: request)
        
        if let httpStatusError = self.httpStatusError(response: response) {
            throw httpStatusError
        }

        do {
            return try decoder.decode(Flights.self, from: data)
        } catch let error {
            throw FlightsLoaderServiceError.decodingError(error)
        }
    }
    
    // MARK: - Private helpers

    private func createRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "s3.amazonaws.com"
        components.path = "/ios-coding-challenge/ios-test-data.json"

        guard let url = components.url else {
            return nil
        }
        
        return URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
    }
    
    private func httpStatusError(
        response: URLResponse?
    ) -> FlightsLoaderServiceError? {
        if let httpResponse = response as? HTTPURLResponse,
            let status = httpResponse.status {
            switch status {
            case .ok:
                return nil

            default:
                return .httpError(status)
            }
        } else {
            return .failedToMatchHTTPStatusCode
        }
    }
}
