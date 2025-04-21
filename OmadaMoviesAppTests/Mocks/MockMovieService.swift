//
//  MockMovieService.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import Foundation
@testable import OmadaMoviesApp

final class MockMovieService: MovieServiceProtocol {
    var queryLog: [(String, Int)] = []
    var result: Result<MovieSearchResponse, Error> = .failure(NSError())

    func searchMovies(query: String, page: Int) async throws -> MovieSearchResponse {
        queryLog.append((query, page))
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
