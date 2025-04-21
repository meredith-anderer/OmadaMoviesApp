//
//  MockNetworkClient.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import Foundation
@testable import OmadaMoviesApp

final class MockNetworkClient: NetworkClientProtocol {
    var requestHandler: ((Endpoint, NetworkService) throws -> Any)?

    func request<T: Decodable>(_ endpoint: Endpoint, service: NetworkService) async throws -> T {
        guard let handler = requestHandler else {
            throw NSError(domain: "MockNetworkClient", code: 0, userInfo: [NSLocalizedDescriptionKey: "No handler provided"])
        }
        guard let result = try handler(endpoint, service) as? T else {
            throw NSError(domain: "MockNetworkClient", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid result type"])
        }
        return result
    }
}
