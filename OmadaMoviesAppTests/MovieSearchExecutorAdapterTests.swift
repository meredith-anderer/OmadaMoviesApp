//
//  MovieSearchExecutorAdapterTests.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import XCTest
@testable import OmadaMoviesApp

final class MovieSearchExecutorAdapterTests: XCTestCase {
    var sut: MovieSearchExecutorAdapter!
    var mockService: MockMovieService!
    
    override func setUp() async throws {
        mockService = MockMovieService()
        sut = MovieSearchExecutorAdapter(service: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
    }
    

    func testAdapterForwardsToService() async {
        // TODO: implement test
    }

    func testAdapterPropagatesErrors() async {
        // TODO: implement test
    }
}
