//
//  MovieDetail.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

import SwiftUI

struct MovieDetail: View {
    @Binding var movie: Movie
    @StateObject var viewModel: MovieViewModel
    
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
        .onAppear() {
            Task {
                try await viewModel.fetchMovieDetail(id: movie.imdbID)
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
        ZStack {
            VStack {
                if let poster = movie.poster {
                    CacheAsyncImage(url: URL(string: poster)) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .frame(width: 200, height: 350)
                                .aspectRatio(contentMode: .fit)
                                .imageScale(.small)
                                .padding(EdgeInsets(top: 70, leading: 0, bottom: 0, trailing: 0))
                        case .empty, .failure(_):
                            Image(systemName: "film")
                                .frame(height: 250)
                                .scaledToFit()
                        @unknown default:
                            Image(systemName: "film")
                                .frame(height: 350)
                                .scaledToFit()
                        }
                    }
                } else {
                    Image(systemName: "film")
                        .resizable(resizingMode: .tile)
                }
                Spacer()
            }
            ScrollView {
                Spacer()
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        HStack {
                            Text(movie.year)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            Spacer()
                            typeView
                        }
                    }
                    .padding()
                    
                    Text(viewModel.movie.plot ?? "")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                        .padding()
                    
                    HStack(alignment: .center) {
                        favoriteView
                        ratingView
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    
                    actorsView
                    awardsView
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .padding(EdgeInsets(top: 430, leading: 0, bottom: 0, trailing: 0))
            }
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder
    private var favoriteView: some View {
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
    
    @ViewBuilder
    private var ratingView: some View {
        if let rating = viewModel.movie.imdbRating {
            ZStack(alignment: .center) {
                Circle()
                    .fill(.cyan)
                    .frame(height: 53)
                Text(rating)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var actorsView: some View {
        if let actors = viewModel.movie.actors {
            VStack(alignment: .leading) {
                Text("Actors")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .italic()
                Text(actors)
                    .font(.title3)
                    .foregroundColor(.white)
                    .italic()
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var awardsView: some View {
        if let awards = viewModel.movie.awards {
            VStack(alignment: .leading) {
                Text("Awards")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .italic()
                Text(awards)
                    .font(.title3)
                    .foregroundColor(.white)
                    .italic()
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var typeView: some View {
        VStack(alignment: .leading) {
            Text(viewModel.movie.type.rawValue)
                .font(.callout)
                .foregroundColor(.white)
                .italic()
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel: MovieViewModel = .init(movie: Movie.sampleData(),
                                                                    viewContext: .init(concurrencyType: .mainQueueConcurrencyType))
    return MovieDetail(movie: $viewModel.movie, viewModel: viewModel)
}
