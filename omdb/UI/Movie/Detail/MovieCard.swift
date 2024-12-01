//
//  MovieCard.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

import SwiftUI

struct MovieCard: View {

    // MARK: - Properties
    @Binding var movie: Movie

    // MARK: - Body
    var body: some View {
        ZStack {
            Color(.gray.opacity(0.05))
            VStack {
                imageContainer
                    .onTapGesture(count: 2) {
                        self.movie.isFavorite.toggle()
                    }
                descriptionContainer
            }
        }.cornerRadius(15)
    }

    // MARK: - Views
    @ViewBuilder
    var imageContainer: some View {
        ZStack {
            if let poster = movie.poster {
                CacheAsyncImage(url: URL(string: poster)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                    case .empty, .failure(_):
                        Image(systemName: "film")
                            .resizable(resizingMode: .tile)
                    @unknown default:
                        Image(systemName: "film")
                            .resizable(resizingMode: .tile)
                    }
                }
            } else {
                Image(systemName: "film")
                    .resizable(resizingMode: .tile)
            }
            VStack {
                Spacer()
                Rectangle()
                    .foregroundStyle(
                        .linearGradient(colors: [.gray.opacity(0.9),
                                                 .gray.opacity(0.1)],
                                        startPoint: .bottomTrailing,
                                        endPoint: .topTrailing)
                    ).frame(height: 20)
            }
        }
    }

    @ViewBuilder
    var descriptionContainer: some View {
        VStack(spacing: 10) {
            titleContainer
            subTitleContainer
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 15)
    }

    @ViewBuilder
    var titleContainer: some View {
        HStack {
            Text("\(movie.title)")
                .lineLimit(1)
                .foregroundColor(.black)
                .bold()
                .font(.system(size: 18))
            Spacer()
        }
    }

    @ViewBuilder
    var subTitleContainer: some View {
        HStack {
            Text("\(movie.year)")
                .foregroundColor(.blue)
                .bold()
            Spacer()
            if movie.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
        .foregroundColor(.red)
        .font(.system(size: 13))
    }
}

#Preview("No favorite") {
    @Previewable @StateObject var viewModel: MovieViewModel = .init(movie: Movie.sampleData(),
                                                                    viewContext: .init(concurrencyType: .mainQueueConcurrencyType))
    MovieCard(movie: $viewModel.movie)
}

#Preview("Favorite") {
    @Previewable @StateObject var viewModel: MovieViewModel = .init(movie: Movie.sampleData(),
                                                                    viewContext: .init(concurrencyType: .mainQueueConcurrencyType))
    MovieCard(movie: $viewModel.movie)
}
