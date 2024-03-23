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
    let mockService = FlightsLoaderServiceMock(session: .shared)
    
    override func setUp() {
        sut = FlightsLoader(service: mockService)
    }
    
    func testLoadFlights() {
        let expectation = expectation(description: "flight fetch")
        var loadedFlights: [String] = []
        sut.loadFlights { flights in
            loadedFlights = flights
            expectation.fulfill()
        }
    	wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(mockService.fetchCallsCount, 1)
        
        XCTAssertEqual(loadedFlights.count, 1500)
        XCTAssertEqual(loadedFlights[0], "edb567a")
        XCTAssertEqual(loadedFlights[1], "edbea29")
        XCTAssertEqual(loadedFlights[2], "edca7e0")
        XCTAssertEqual(loadedFlights[3], "edcbeb1")
        XCTAssertEqual(loadedFlights[4], "edcc399")
        XCTAssertEqual(loadedFlights[5], "edccebd")
    }
    
    func testLoadFlights_IATAsAlreadyLoaded() {
        let iatasExpectation = expectation(description: "IATA fetch")
        let flightExpectation = expectation(description: "flight fetch")
        
        sut.loadIATAs { _ in iatasExpectation.fulfill()}
        wait(for: [iatasExpectation], timeout: 2)
        
        var loadedFlights: [String] = []
        sut.loadFlights { flights in
            loadedFlights = flights
            flightExpectation.fulfill()
        }
        wait(for: [flightExpectation], timeout: 2)
        
        XCTAssertEqual(mockService.fetchCallsCount, 1)
        
        XCTAssertEqual(loadedFlights.count, 1500)
        XCTAssertEqual(loadedFlights[0], "edb567a")
        XCTAssertEqual(loadedFlights[1], "edbea29")
        XCTAssertEqual(loadedFlights[2], "edca7e0")
        XCTAssertEqual(loadedFlights[3], "edcbeb1")
        XCTAssertEqual(loadedFlights[4], "edcc399")
        XCTAssertEqual(loadedFlights[5], "edccebd")
    }
    
    func testLoadIATAs() {
        let expectation = expectation(description: "IATA fetch")
        var loadedFromIATAs: [String] = []
        var loadedToIATAs: [String] = []
        sut.loadIATAs { iatas in
            loadedFromIATAs = iatas.from
            loadedToIATAs = iatas.to
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(mockService.fetchCallsCount, 1)
        
        XCTAssertEqual(loadedFromIATAs.count, 292)
        XCTAssertEqual(loadedFromIATAs[0], "AAQ")
        XCTAssertEqual(loadedFromIATAs[1], "ACE")
        XCTAssertEqual(loadedFromIATAs[2], "ADD")
        XCTAssertEqual(loadedFromIATAs[3], "ADL")
        XCTAssertEqual(loadedFromIATAs[4], "AEP")
        XCTAssertEqual(loadedFromIATAs[5], "AES")
        
        XCTAssertEqual(loadedToIATAs.count, 287)
        XCTAssertEqual(loadedToIATAs[0], "AAE")
        XCTAssertEqual(loadedToIATAs[1], "AAL")
        XCTAssertEqual(loadedToIATAs[2], "AAN")
        XCTAssertEqual(loadedToIATAs[3], "ACE")
        XCTAssertEqual(loadedToIATAs[4], "AER")
        XCTAssertEqual(loadedToIATAs[5], "AGP")
    }
    
    func testLoadIATAs_FlightsAlreadyLoaded() {
        let flightExpectation = expectation(description: "flight fetch")
        let iatasExpectation = expectation(description: "IATA fetch")

        sut.loadFlights { _ in flightExpectation.fulfill() }
        wait(for: [flightExpectation], timeout: 2)

        var loadedFromIATAs: [String] = []
        var loadedToIATAs: [String] = []
        sut.loadIATAs { iatas in
            loadedFromIATAs = iatas.from
            loadedToIATAs = iatas.to
            iatasExpectation.fulfill()
        }
        wait(for: [iatasExpectation], timeout: 2)
        
        XCTAssertEqual(mockService.fetchCallsCount, 1)
        
        XCTAssertEqual(loadedFromIATAs.count, 292)
        XCTAssertEqual(loadedFromIATAs[0], "AAQ")
        XCTAssertEqual(loadedFromIATAs[1], "ACE")
        XCTAssertEqual(loadedFromIATAs[2], "ADD")
        XCTAssertEqual(loadedFromIATAs[3], "ADL")
        XCTAssertEqual(loadedFromIATAs[4], "AEP")
        XCTAssertEqual(loadedFromIATAs[5], "AES")
        
        XCTAssertEqual(loadedToIATAs.count, 287)
        XCTAssertEqual(loadedToIATAs[0], "AAE")
        XCTAssertEqual(loadedToIATAs[1], "AAL")
        XCTAssertEqual(loadedToIATAs[2], "AAN")
        XCTAssertEqual(loadedToIATAs[3], "ACE")
        XCTAssertEqual(loadedToIATAs[4], "AER")
        XCTAssertEqual(loadedToIATAs[5], "AGP")
    }
    
    func testRoute_SuccessDirect() throws {
        let from = "DXB"
        let to = "FLL"
        let expectation = expectation(description: "IATA fetch")
        var loadedFromIATAs: [String] = []
        var loadedToIATAs: [String] = []
        sut.loadIATAs { iatas in
            loadedFromIATAs = iatas.from
            loadedToIATAs = iatas.to
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(mockService.fetchCallsCount, 1)
        
        XCTAssertEqual(loadedFromIATAs.count, 292)
        XCTAssertEqual(loadedToIATAs.count, 287)
        
        let route = try XCTUnwrap(sut.calculateRoute(from: from, to: to))
        XCTAssertEqual(route.count, 1)
        XCTAssertEqual(route[0].fromIATA, from)
        XCTAssertEqual(route[0].toIATA, to)
    }
    
    // TODO: Find good test data
//    func testRoute_SuccessLayover() throws {
//        let from = "???"
//        let layover = "???"
//        let to = "???"
//        let expectation = expectation(description: "IATA fetch")
//        var loadedFromIATAs: [String] = []
//        var loadedToIATAs: [String] = []
//        sut.loadIATAs { iatas in
//            loadedFromIATAs = iatas.from
//            loadedToIATAs = iatas.to
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 2)
//        
//        XCTAssertEqual(mockService.fetchCallsCount, 1)
//        
//        XCTAssertEqual(loadedFromIATAs.count, 292)
//        XCTAssertEqual(loadedToIATAs.count, 287)
//        
//        let route = try XCTUnwrap(sut.calculateRoute(from: from, to: to))
//        XCTAssertEqual(route.count, 2)
//        XCTAssertEqual(route[0].fromIATA, from)
//        XCTAssertEqual(route[0].toIATA, layover)
//        XCTAssertEqual(route[1].fromIATA, layover)
//        XCTAssertEqual(route[1].toIATA, to)
//    }
    
    func testRoute_FailureNoFlightData() throws {
        let from = "DXB"
        let to = "FLL"
        
        XCTAssertEqual(mockService.fetchCallsCount, 0)
        XCTAssertNil(sut.calculateRoute(from: from, to: to))
    }
    
    func testRoute_FailureNoFrom() throws {
        let from: String? = nil
        let to = "FLL"
        let expectation = expectation(description: "IATA fetch")
        var loadedFromIATAs: [String] = []
        var loadedToIATAs: [String] = []
        sut.loadIATAs { iatas in
            loadedFromIATAs = iatas.from
            loadedToIATAs = iatas.to
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(mockService.fetchCallsCount, 1)
        
        XCTAssertEqual(loadedFromIATAs.count, 292)
        XCTAssertEqual(loadedToIATAs.count, 287)
        
        XCTAssertNil(sut.calculateRoute(from: from, to: to))
    }
    
    func testRoute_FailureNoTo() throws {
        let from = "DXB"
        let to: String? = nil
        let expectation = expectation(description: "IATA fetch")
        var loadedFromIATAs: [String] = []
        var loadedToIATAs: [String] = []
        sut.loadIATAs { iatas in
            loadedFromIATAs = iatas.from
            loadedToIATAs = iatas.to
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(mockService.fetchCallsCount, 1)
        
        XCTAssertEqual(loadedFromIATAs.count, 292)
        XCTAssertEqual(loadedToIATAs.count, 287)
        
        XCTAssertNil(sut.calculateRoute(from: from, to: to))
    }
    
    func testRoute_FailureToAndFromSame() throws {
        let from = "FLL"
        let to = "FLL"
        let expectation = expectation(description: "IATA fetch")
        var loadedFromIATAs: [String] = []
        var loadedToIATAs: [String] = []
        sut.loadIATAs { iatas in
            loadedFromIATAs = iatas.from
            loadedToIATAs = iatas.to
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(mockService.fetchCallsCount, 1)
        
        XCTAssertEqual(loadedFromIATAs.count, 292)
        XCTAssertEqual(loadedToIATAs.count, 287)
        
        XCTAssertNil(sut.calculateRoute(from: from, to: to))
    }
}
