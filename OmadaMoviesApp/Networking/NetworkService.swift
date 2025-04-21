//
//  NetworkService.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import Foundation

protocol NetworkService {
    var baseURL: URL { get }
    var defaultHeaders: [String: String]? { get }
}

extension NetworkService {
    var defaultHeaders: [String: String]? { nil }
} 
