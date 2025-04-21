//
//  MovieSearchExecutorAdapter.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

protocol MovieSearchExecutor {
    func search(query: String, page: Int) async throws -> MovieSearchResponse
}

/// An adapter that allows a `MovieServiceProtocol` to conform to the `MovieSearchExecutor` interface.
/// This is useful for abstracting away the details of the service implementation from the ViewModel.
///
/// This adapter is also a good place to introduce cross-cutting concerns like:
/// - Caching layer
/// - Logging / Analytics
/// - Retry
struct MovieSearchExecutorAdapter: MovieSearchExecutor {
    private let service: MovieServiceProtocol

    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }

    func search(query: String, page: Int) async throws -> MovieSearchResponse {
        try await service.searchMovies(query: query, page: page)
    }
}
