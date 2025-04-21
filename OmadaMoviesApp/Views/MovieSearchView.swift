//
//  MovieSearchView.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import SwiftUI

struct MovieSearchView: View {
    @StateObject private var viewModel = MovieSearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                SearchBar(text: $viewModel.searchText)
                    .padding()
                Divider()
                
                ScrollView {
                    contentView
                }
            }
            .navigationTitle("Movie Search")
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.movies.isEmpty {
            if viewModel.isNewSearchLoading {
                ProgressView()
                    .containerRelativeFrame(.vertical)
            } else {
                Text("No results")
                    .foregroundColor(.gray)
                    .containerRelativeFrame(.vertical)
            }
        } else if let error = viewModel.newSearchError {
            errorView(message: error, retryAction: viewModel.retrySearch)
        }  else {
            VStack {
                movieList(movies: viewModel.movies)
                
                if viewModel.isPaginationLoading {
                    ProgressView()
                        .padding()
                } else if let paginationError = viewModel.paginationError {
                    errorView(message: paginationError, retryAction: viewModel.retryPagination)
                        .padding()
                }
            }
        }
    }
    
    private func movieList(movies: [Movie]) -> some View {
        LazyVStack(spacing: 8) {
            ForEach(movies) { movie in
                NavigationLink {
                    MovieDetailView(movie: movie)
                } label: {
                    movieRow(movie: movie)
                        .task {
                            viewModel.loadMoreMoviesIfNeeded(currentItem: movie)
                        }
                }
                Divider()
            }
        }
        .padding(.horizontal)
    }
    
    private func errorView(message: String, retryAction: @escaping () -> Void) -> some View {
        VStack(spacing: 12) {
            Text(message)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)

            Button("Retry", action: retryAction)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue)
                .cornerRadius(8)
        }
    }
    
    private func movieRow(movie: Movie) -> some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: movie.posterURL) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: 80, height: 125)
            .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                if let year = movie.releaseYear {
                    Text(year)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    MovieSearchView()
}
