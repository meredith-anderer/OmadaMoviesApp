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
    @Published private(set) var isPaginating: Bool = false
    @Published private(set) var errorMessage: String? = nil
    
    private let movieService = MovieService()
    private var searchTask: Task<Void, Never>?
    private var searchTextCancellable: AnyCancellable?
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    
    init() {
        observeSearchText()
    }
    
    private func observeSearchText() {
        searchTextCancellable = $searchText
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard !searchText.isEmpty else {
                    self?.resetSearch()
                    return
                }
                self?.performSearch(with: searchText)
            }
    }
    
    private func resetSearch() {
        movies = []
        currentPage = 1
        totalPages = 1
        errorMessage = nil
        searchTask?.cancel()
    }
    
    private func performSearch(with query: String) {
        // Cancel any existing search task
        searchTask?.cancel()
        
        // Reset state for new search
        resetSearch()
        
        // Store the query we're searching for
        let currentQuery = query
        
        // Create a new search task
        searchTask = Task {
            isLoading = true
            errorMessage = nil
            defer {
                isLoading = false
            }
            
            do {
                let response = try await movieService.searchMovies(query: query, page: currentPage)
                
                // Verify this is still the current search
                guard !Task.isCancelled && searchText == currentQuery else { return }
                
                movies = response.results
                totalPages = response.totalPages
            } catch {
                // Only show error if this is still the current search
                if searchText == currentQuery {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadMoreMoviesIfNeeded(currentItem item: Movie?) {
        guard let item = item else {
            return
        }
        
        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -5)
        if movies.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadNextPage()
        }
    }
    
    private func loadNextPage() {
        guard !isLoading,
              !isPaginating,
              currentPage < totalPages,
              !searchText.isEmpty else {
            return
        }
        
        searchTask?.cancel()
        
        // Store the query we're paginating for
        let currentQuery = searchText
        
        searchTask = Task {
            isPaginating = true
            errorMessage = nil
            defer {
                isPaginating = false
            }
            
            do {
                let nextPage = currentPage + 1
                let response = try await movieService.searchMovies(query: currentQuery, page: nextPage)
                
                // Verify this is still the current search
                guard !Task.isCancelled && searchText == currentQuery else { return }
                
                movies.append(contentsOf: response.results)
                currentPage = response.page
                totalPages = response.totalPages
            } catch {
                // Only show error if this is still the current search
                if searchText == currentQuery {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
