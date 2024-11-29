//
//  MovieDetail.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

import SwiftUI

struct MovieDetail: View {
    @Binding var movie: Movie
    var viewModel: MovieViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Color(.black)
                background
                    .blur(radius: 20, opaque: true)
                content
            }
            .edgesIgnoringSafeArea(.all)
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
        .onChange(of: movie.isFavorite) { oldValue, newValue in
            if newValue {
                viewModel.saveFavoriteMovie()
            } else {
                viewModel.deleteFavoriteMovie()
            }
        }
    }
    
    @ViewBuilder
    private var background: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.mint)
                if let poster = movie.poster {
                    CacheAsyncImage(url: URL(string: poster)) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .imageScale(.small)
                        case .empty, .failure(_):
                            Image(systemName: "film")
                                .frame(height: 211)
                                .scaledToFit()
                        @unknown default:
                            Image(systemName: "film")
                                .frame(height: 211)
                                .scaledToFit()
                        }
                    }
                } else {
                    Image(systemName: "film")
                        .resizable(resizingMode: .tile)
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        VStack {
            if let poster = movie.poster {
                CacheAsyncImage(url: URL(string: poster)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .frame(height: 350)
                            .aspectRatio(contentMode: .fit)
                            .imageScale(.small)
                    case .empty, .failure(_):
                        Image(systemName: "film")
                            .frame(height: 211)
                            .scaledToFit()
                    @unknown default:
                        Image(systemName: "film")
                            .frame(height: 211)
                            .scaledToFit()
                    }
                }
            } else {
                Image(systemName: "film")
                    .resizable(resizingMode: .tile)
            }
            Text(movie.title)
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.bold)
            Text(movie.year)
                .font(.subheadline)
                .foregroundColor(.white)
                .fontWeight(.bold)
            favorite
        }
    }
    
    @ViewBuilder
    private var favorite: some View {
        Button(action: {
            self.movie.isFavorite.toggle()
        }) {
            if movie.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color.yellow))
            } else {
                Image(systemName: "star.fill")
                    .foregroundColor(.gray)
                    .padding()
                    .background(Circle().fill(Color.white))
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel: MovieViewModel = .init(movie: .init(title: "Deadpool",
                                                                                 year: "2016",
                                                                                 imdbID: "tt1431045",
                                                                                 type: .movie,
                                                                                 poster: "https://m.media-amazon.com/images/M/MV5BNzY3ZWU5NGQtOTViNC00ZWVmLTliNjAtNzViNzlkZWQ4YzQ4XkEyXkFqcGc@._V1_SX300.jpg",
                                                                                 isFavorite: false),
                                                                    viewContext: .init(concurrencyType: .mainQueueConcurrencyType))
    return MovieDetail(movie: $viewModel.movie, viewModel: viewModel)
}
