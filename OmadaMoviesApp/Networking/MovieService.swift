import Foundation

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

class MovieService: NetworkService {
    private let client: NetworkClient
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org")!
    }
    
    var defaultHeaders: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    init(client: NetworkClient = NetworkClient.shared) {
        self.client = client
    }
    
    func searchMovies(query: String, page: Int = 1) async throws -> MovieSearchResponse {
        let endpoint = MovieEndpoint.search(query: query, page: page)
        return try await client.request(endpoint, service: self)
    }
}
