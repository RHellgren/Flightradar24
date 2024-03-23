//
//  FlightsLoaderTests.swift
//  FR24ChallengeTests
//
//  Created by Robin Hellgren on 23/03/2024.
//

@testable import FR24Challenge

import XCTest

final class FlightsLoaderTests: XCTestCase {
    
    var sut: FlightsLoader!
    
    override func setUp() {
        let service = FlightsLoaderServiceMock(session: .shared)
        sut = FlightsLoader(service: service)
    }
    
    func testLoadFlights() {
        let expectation = expectation(description: "flight fetch")
        var loadedFlights: [String] = []
        sut.loadFlights { flights in
            loadedFlights = flights
            expectation.fulfill()
        }
    	wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(loadedFlights.count, 1500)
        XCTAssertEqual(loadedFlights[0], "edb567a")
        XCTAssertEqual(loadedFlights[1], "edbea29")
        XCTAssertEqual(loadedFlights[2], "edca7e0")
        XCTAssertEqual(loadedFlights[3], "edcbeb1")
        XCTAssertEqual(loadedFlights[4], "edcc399")
        XCTAssertEqual(loadedFlights[5], "edccebd")
    }
}
