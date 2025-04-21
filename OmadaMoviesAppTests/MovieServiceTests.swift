//
//  MovieServiceTests.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import XCTest
@testable import OmadaMoviesApp

final class MovieServiceTests: XCTestCase {
    var sut: MovieService!
    var mockNetworkClient: MockNetworkClient!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        sut = MovieService(client: mockNetworkClient)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkClient = nil
        super.tearDown()
    }
    
    
    func testSearchMovies_Success() async throws {
        // TODO: make all values random and create helpers for returning random versions of objects
        let expected = MovieSearchResponse(page: 1, results: [Movie(adult: Bool.random(), backdropPath: nil, genreIds: [], id: 423, originalLanguage: "en", originalTitle: "Interstellar", overview: "Space is cool but scary.", popularity: 42.0, posterPath: "/poster", releaseDate: "2023-01-01", title: "Interstellar", video: Bool.random(), voteAverage: 9.34, voteCount: 754)], totalPages: 1, totalResults: 1)

        mockNetworkClient.requestHandler = { endpoint, service in
            // TODO: assert on endpoint path/query here
            return expected
        }

        let result = try await sut.searchMovies(query: "Interstellar", page: 1)
        XCTAssertEqual(result, expected)
    }
    
    
    func testSearchMovies_ThrowsError() async {
         mockNetworkClient.requestHandler = { _, _ in
             throw NSError(domain: "Network", code: 500)
         }

         do {
             _ = try await sut.searchMovies(query: "Inception", page: 1)
             XCTFail("Expected error to be thrown")
         } catch {
             XCTAssertEqual((error as NSError).code, 500)
         }
     }
    // TODO: refine and add tests
}
