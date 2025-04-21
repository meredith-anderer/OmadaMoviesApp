//
//  MovieSearchViewModel.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import Foundation
import Combine

@MainActor
class MovieSearchViewModel<S: Scheduler>: ObservableObject {
    @Published var searchText: String = ""
    @Published private(set) var isNewSearchLoading = false
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var newSearchError: String?
    @Published private(set) var isPaginationLoading = false
    @Published private(set) var paginationError: String?
    
    private var currentPage = 1
    private var totalPages = 1
    private var searchTask: Task<Void, Never>?
    private var paginationTask: Task<Void, Never>?
    private var searchTextCancellable: AnyCancellable?
    private let scheduler: S
    
    private let executor: MovieSearchExecutor
    
    init(
        executor: MovieSearchExecutor = MovieSearchExecutorAdapter(),
        scheduler: S = RunLoop.main
    ) {
        self.executor = executor
        self.scheduler = scheduler
        observeSearchText()
    }
    
    private func observeSearchText() {
        searchTextCancellable = $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: scheduler)
            .sink { [weak self] newText in
                self?.handleSearchTextChange(newText)
            }
    }
    
    private func handleSearchTextChange(_ text: String) {
        guard !text.isEmpty else {
            movies = []
            newSearchError = nil
            paginationError = nil
            currentPage = 1
            totalPages = 1
            return
        }
        performSearch(query: text)
    }
    
    func performSearch(query: String) {
        searchTask?.cancel()
        
        currentPage = 1
        totalPages = 1
        movies = []
        newSearchError = nil
        paginationError = nil
        
        searchTask = Task {
            isNewSearchLoading = true
            
            do {
                let response = try await executor.search(query: query, page: 1)
                guard !Task.isCancelled && self.searchText == query else { return }
                
                currentPage = 1
                totalPages = response.totalPages
                movies = response.results
                
            } catch {
                if !Task.isCancelled {
                    self.newSearchError = error.localizedDescription
                }
            }
            
            isNewSearchLoading = false
        }
    }
    
    func loadMoreMoviesIfNeeded(currentItem item: Movie?) {
        guard
            let item,
            let index = movies.firstIndex(where: { $0.id == item.id }),
            index >= movies.count - 5,
            currentPage < totalPages,
            !isPaginationLoading,
            paginationTask == nil
        else { return }
        
        loadNextPage(query: searchText)
    }
    
    private func loadNextPage(query: String) {
        guard !isPaginationLoading else { return }
        
        paginationTask = Task {
            isPaginationLoading = true
            paginationError = nil
            let nextPage = currentPage + 1
            
            do {
                let response = try await executor.search(query: query, page: nextPage)
                
                guard !Task.isCancelled && self.searchText == query else { return }
                
                currentPage = nextPage
                totalPages = response.totalPages
                movies.append(contentsOf: response.results)
                
            } catch {
                if !Task.isCancelled {
                    paginationError = error.localizedDescription
                }
            }
            
            isPaginationLoading = false
            paginationTask = nil
        }
    }
    
    func retrySearch() {
        guard !searchText.isEmpty else { return }
        performSearch(query: searchText)
    }
    
    func retryPagination() {
        guard !searchText.isEmpty else { return }
        paginationError = nil
        loadNextPage(query: searchText)
    }
}

