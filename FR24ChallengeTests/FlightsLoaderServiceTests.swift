//
//  FlightsLoaderServiceTests.swift
//  FR24ChallengeTests
//
//  Created by Robin Hellgren on 23/03/2024.
//

@testable import API

import XCTest

final class FlightsLoaderServiceTests: XCTestCase {
    
    var sut: FlightsLoaderService!
    private let apiURL = URL(string: "https://s3.amazonaws.com/ios-coding-challenge/ios-test-data.json")!

    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        sut = FlightsLoaderServiceImpl(session: urlSession)
    }

    func testFetchSuccess() async throws {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let mockData = MockData().readJSONFile(fileName: "Flights_mock")

            return (response, mockData)
        }
        
        let response = try await sut.fetch()
        
        XCTAssertEqual(response.count, 15730)
        XCTAssertEqual(response.version, 2020)
        XCTAssertEqual(response.copyright, "The contents of this file and all derived data are the property of Flightradar24 AB for use exclusively by its products and applications. Using, modifying or redistributing the data without the prior written permission of Flightradar24 AB is not allowed and may result in prosecutions.")
        XCTAssertEqual(response.aircraft.count, 1500)
        
        let firstItem = try XCTUnwrap(response.aircraft.first)
        XCTAssertEqual(firstItem.flightId, "edb567a")
        XCTAssertEqual(firstItem.aircraftId, "896177")
        XCTAssertEqual(firstItem.latitude, 30.6522)
        XCTAssertEqual(firstItem.longitude, -69.7767)
        XCTAssertEqual(firstItem.track, 246)
        XCTAssertEqual(firstItem.altitude, 38000)
        XCTAssertEqual(firstItem.speed, 448)
        XCTAssertEqual(firstItem.squawk, "4613")
        XCTAssertEqual(firstItem.radarName, "F-TXKF2")
        XCTAssertEqual(firstItem.aircraftModel, "B77L")
        XCTAssertEqual(firstItem.aircraftRegistration, "A6-EWE")
        XCTAssertEqual(firstItem.timestamp, 1505481740)
        XCTAssertEqual(firstItem.fromIata, "DXB")
        XCTAssertEqual(firstItem.toIata, "FLL")
        XCTAssertEqual(firstItem.flightNumber, "EK213")
        XCTAssertEqual(firstItem.onGround, 0)
        XCTAssertEqual(firstItem.verticalSpeed, 0)
        XCTAssertEqual(firstItem.callsign, "UAE213")
    }
    
    func testStatusCodeFailure() async throws {
        let statusCode = 404
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.apiURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)!

            return (response, nil)
        }
        
        do {
            _ = try await sut.fetch()
            XCTFail("Expected error not success")
        } catch FlightsLoaderServiceError.httpError(let error) {
            let status = try XCTUnwrap(error as? HTTPStatusCode)
            XCTAssertEqual(status, HTTPStatusCode(rawValue: statusCode)!)
        } catch {
            XCTFail("Expected error not thrown")
        }
    }
    
    func testStatusCodeUnknownFailure() async throws {
        let statusCode = 999
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.apiURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)!

            return (response, nil)
        }
        
        do {
            _ = try await sut.fetch()
            XCTFail("Expected error not success")
        } catch FlightsLoaderServiceError.failedToMatchHTTPStatusCode {
            // Expected state, no action
        } catch {
            XCTFail("Expected error not thrown")
        }
    }
    
    func testDecodingFailure() async throws {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let mockData = Data()

            return (response, mockData)
        }
        
        do {
            _ = try await sut.fetch()
            XCTFail("Expected error not success")
        } catch FlightsLoaderServiceError.decodingError(let error) {
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
        } catch {
            XCTFail("Expected error not thrown")
        }
    }
}
