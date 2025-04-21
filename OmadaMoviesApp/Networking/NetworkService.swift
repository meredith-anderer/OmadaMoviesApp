import Foundation

protocol NetworkService {
    var baseURL: URL { get }
    var defaultHeaders: [String: String]? { get }
}

extension NetworkService {
    var defaultHeaders: [String: String]? { nil }
} 