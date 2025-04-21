//
//  MovieSearchViewModelTests.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import XCTest
import Combine
@testable import OmadaMoviesApp

@MainActor
final class MovieSearchViewModelTests: XCTestCase {
    var sut: MovieSearchViewModel<ImmediateScheduler>!
    var executor: MockMovieSearchExecutor!

    override func setUp() {
        super.setUp()
        executor = MockMovieSearchExecutor()
        sut = MovieSearchViewModel(executor: executor, scheduler: ImmediateScheduler.shared)
    }

    
    override func tearDown() {
        sut = nil
        executor = nil
    }
    
    func testInitialState() {
        XCTAssertEqual(sut.state, .idle)
    }
    
    // TODO: add tests
}
