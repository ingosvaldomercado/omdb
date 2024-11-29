//
//  MovieList.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

import SwiftUI

struct MovieList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = MovieListViewModel()
    @State private var query: String = ""
    @State private var searchDone: Bool = false
    @State private var hasError: Bool = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteMovie.imdbId, ascending: true)],
        animation: .default)
    private var favoriteMovies: FetchedResults<FavoriteMovie>
    
    // MARK: - Grid Configuration
    private var twoColumnGrid = [GridItem(.flexible(), spacing: 8),
                                 GridItem(.flexible(), spacing: 8)]
    
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    TextField("Search movies...", text: $query, onCommit: {
                        performSearch(isFromScroll: false)
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    Button(action: {
                        performSearch(isFromScroll: false)
                    }) {
                        Text("Search")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                
                if hasError {
                    Spacer()
                    Text("Something wrong has happen... \(viewModel.errorMessage ?? "unexpected error")")
                    Spacer()
                } else if !viewModel.movies.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: twoColumnGrid, spacing: 8) {
                            ForEach($viewModel.movies) { movie in
                                NavigationLink(destination: MovieDetail(movie: movie,
                                                                        viewModel: MovieViewModel(movie: movie.wrappedValue,
                                                                                                  viewContext: viewContext))) {
                                    MovieCard(movie: movie)
                                        .id(movie.id)
                                        .frame(height: 350)
                                        .onAppear() {
                                            if movie.wrappedValue == viewModel.movies.last {
                                                performSearch(isFromScroll: true)
                                            }
                                        }
                                }
                            }
                        }
                        .padding()
                    }
                } else if viewModel.movies.isEmpty && query.isEmpty {
                    Spacer()
                    Text("Write a name of the movie you wanted to search...")
                    Spacer()
                } else if searchDone && viewModel.movies.isEmpty {
                    Spacer()
                    Text("No movies found")
                    Spacer()
                } else if !searchDone {
                    Spacer()
                    Text("Searching movies...")
                    Spacer()
                
                } else {
                    
                }
            }.onChange(of: viewModel.isComplete) { oldValue, newValue in
                searchDone = newValue
            }
            .onChange(of: viewModel.isError) { oldValue, newValue in
                self.hasError = newValue
            }
            .onChange(of: viewModel.movies) { oldValue, newValue in
                print("Esta película tuvo un cambio de valor \(newValue)")
            }
            #if DEBUG
            /*
             This is for testing purpose
             .onAppear() {
                Task {
                    try await viewModel.fetchMovies(query: "dead")
                }
            }*/
            #endif
        }
    }
    
    private func performSearch(isFromScroll: Bool) {
        self.hasError = false
        Task {
            try await viewModel.fetchMovies(query: query, viewContext: viewContext, isFromScroll: isFromScroll)
        }
    }
}

#Preview {
    return MovieList()
}

