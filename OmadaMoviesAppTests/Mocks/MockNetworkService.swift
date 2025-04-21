//
//  MockNetworkService.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import Foundation
@testable import OmadaMoviesApp

final class MockNetworkService: NetworkService {
    var baseURL: URL = URL(string: "https://mock.api")!
    var defaultHeaders: [String: String]? = ["Authorization": "Bearer test"] 
}
