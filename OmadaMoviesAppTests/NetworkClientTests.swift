//
//  NetworkClientTests.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import XCTest
@testable import OmadaMoviesApp

final class NetworkClientTests: XCTestCase {
    var sut: NetworkClient!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        sut = NetworkClient(session: mockURLSession)
    }
    
    override func tearDown() {
        sut = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    // TODO: add tests
}
