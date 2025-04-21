//
//  MovieDetailView.swift
//  OmadaMoviesApp
//
//  Created by Meredith Anderer on 4/21/25.
//

import SwiftUI

struct MovieDetailView: View {
    
    var movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Divider()
                
                HStack(spacing: 16) {
                    AsyncImage(url: movie.posterURL) { image in
                        image.resizable()
                    } placeholder: {
                        Color(.gray)
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        if let date = movie.formattedReleaseDate {
                            Text(date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("Viewer rating")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        ProgressView(value: movie.voteAverage, total: 10) {
                            Text("\(movie.formattedVoteAverage)/10")
                        }
                        
                    }
                }
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("OVERVIEW")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text(movie.overview)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                Divider()
            }
            .multilineTextAlignment(.leading)
            .padding()

        }
                
    }
}

#Preview {
    MovieDetailView(
        movie: Movie(
            adult: false,
            backdropPath: "/fiKxHSBFehZ3cImlz2YanWpreOv.jpg",
            genreIds: [
                16,
                18,
                14
            ],
            id: 588555,
            originalLanguage: "pt",
            originalTitle: "Os Demónios do Meu Avô",
            overview: "Rosa's life, a highly valued professional, is turned upside down when her grandfather Marcelino dies.",
            popularity: 8.5666,
            posterPath: "/fPoUd6lm011MUCH54aNeMsDJl7z.jpg",
            releaseDate: "2022-09-21",
            title: "My Grandfather's Demons",
            video: false,
            voteAverage: 5.709,
            voteCount: 79
        )
    )
}
