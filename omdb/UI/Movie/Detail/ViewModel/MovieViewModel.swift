//
//  MovieViewModel.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

import CoreData
import SwiftUI

@MainActor
class MovieViewModel: ObservableObject {
    @Published var movie: Movie
    let viewContext: NSManagedObjectContext
    
    init(movie: Movie, viewContext: NSManagedObjectContext) {
        self.movie = movie
        self.viewContext = viewContext
    }
    
    func fetchMovieDetail(id: String) async throws {
        do {
            let client = MovieClient(endpoint: .detail(id: id))
            let result: MovieResponse = try await client.performAndDecode()
            
            let favoriteIds = movie.isFavorite ? Set([movie.imdbID]) : []
            self.movie = MovieAdapter.adapt(from: result, favoriteIds: favoriteIds)
            
            print("Fetched movie list: \(result)")
        } catch let APIError.apiError(message) {
            print("Api error: \(message)")
        } catch {
            print("Unexpected error")
        }
    }
    
    func saveFavoriteMovie() {
        let newMovie = FavoriteMovie(context: viewContext)
        newMovie.title = movie.title
        newMovie.year = movie.year
        newMovie.imdbId = movie.imdbID
        do {
            try viewContext.save()
        } catch {
            print("Error saving the movie")
        }
    }
    
    func deleteFavoriteMovie() {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbId == %@", movie.imdbID)
            
        do {
            let results = try viewContext.fetch(fetchRequest)
            results.forEach {
                viewContext.delete($0)
            }
        } catch {
            print("Error removing favorite movies: \(error)")
            return
        }
    }
}
