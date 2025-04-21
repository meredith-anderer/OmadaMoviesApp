//
//  MockURLSession.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import Foundation
@testable import OmadaMoviesApp

final class MockURLSession: URLSessionProtocol {
    var responseData: Data?
    var urlResponse: URLResponse?
    var error: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        guard let data = responseData, let response = urlResponse else {
            throw URLError(.badServerResponse)
        }
        return (data, response)
    }
}
