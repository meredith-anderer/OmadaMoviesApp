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
        NavigationStack{
            VStack {
                Divider()
                SearchBar(text: $viewModel.searchText)
                    .padding()
                Divider()
                contentView
            }
            .navigationTitle("Movie Search")
        }
    }
    
    struct SearchBar: View {
        @Binding var text: String
        var body: some View {
            HStack {
                Image(systemName: "magnifyingglass").foregroundStyle(.gray)
                TextField("Search", text: $text)
                
                if !text.isEmpty {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.gray).onTapGesture {
                        text = ""
                    }
                }
            }
            .padding(8)
            .background(Color.secondary.opacity(0.2))
            .cornerRadius(8)
    
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.movies.isEmpty {
            Spacer()
            Text("No results")
                .foregroundColor(.gray)
            Spacer()
        } else {
            movieList
        }
    }
    
    private var movieList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.movies) { movie in
                    NavigationLink {
                        MovieDetailView(movie: movie)
                    } label: {
                        MovieRow(movie: movie)
                    }
                    Divider()
                }
            }
        }
        .padding(.horizontal)
    }
    
    private struct MovieRow: View {
        let movie: Movie
        
        var body: some View {
            HStack(alignment: .top, spacing: 16) {
                AsyncImage(url: movie.posterURL) { image in
                    image.resizable()
                } placeholder: {
                    Color(.gray)
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
                .multilineTextAlignment(.leading)
                
                Spacer()
            }
        }
    }
}

#Preview {
    MovieSearchView()
}
