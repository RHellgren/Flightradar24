//
//  FlightsLoaderServiceError.swift
//  API
//
//  Created by Robin Hellgren on 23/03/2024.
//

import Foundation

enum FlightsLoaderServiceError: Error {
    case urlParsingFailed
    case httpError(Error)
    case failedToMatchHTTPStatusCode
    case decodingError(Error)
}
