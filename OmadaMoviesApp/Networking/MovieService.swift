//
//  MovieService.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import Foundation

protocol MovieServiceProtocol {
    func searchMovies(query: String, page: Int) async throws -> MovieSearchResponse
}


class MovieService: NetworkService, MovieServiceProtocol {
    private let client: NetworkClientProtocol
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org")!
    }
    
    var defaultHeaders: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    init(client: NetworkClientProtocol = NetworkClient.shared) {
        self.client = client
    }
    
    func searchMovies(query: String, page: Int = 1) async throws -> MovieSearchResponse {
        let endpoint = MovieEndpoint.search(query: query, page: page)
        return try await client.request(endpoint, service: self)
    }
}

// MARK: - Endpoints
private extension MovieService {
    enum MovieEndpoint: Endpoint {
        case search(query: String, page: Int = 1)
        
        var path: String {
            switch self {
            case .search:
                return "/3/search/movie"
            }
        }
        
        var queryItems: [URLQueryItem]? {
            switch self {
            case .search(let query, let page):
                return [
                    URLQueryItem(name: "api_key", value: "b11fc621b3f7f739cb79b50319915f1d"),
                    URLQueryItem(name: "query", value: query),
                    URLQueryItem(name: "page", value: String(page)),
                    URLQueryItem(name: "language", value: "en-US"),
                    URLQueryItem(name: "include_adult", value: "false")
                ]
            }
        }
    }
}
