//
//  MovieSearchViewModel.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import Foundation
import Combine

@MainActor
class MovieSearchViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published var searchText: String = ""
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil
    
    private let movieService = MovieService()
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    init() {
        observeSearchText()
    }
    
    private func observeSearchText() {
        $searchText
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard !searchText.isEmpty else {
                    self?.movies = []
                    return
                }
                self?.performSearch(with: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(with query: String) {
        // Cancel any existing search task
        searchTask?.cancel()
        
        // Create a new search task
        searchTask = Task {
            isLoading = true
            errorMessage = nil
            defer {
                isLoading = false
            }
            
            do {
                let response = try await movieService.searchMovies(query: query)
                
                guard !Task.isCancelled else { return }
                
                movies = response.results
            } catch {
                // TODO: improved error handling/ do something with error
                errorMessage = error.localizedDescription
            }
            
        }
    }
}
