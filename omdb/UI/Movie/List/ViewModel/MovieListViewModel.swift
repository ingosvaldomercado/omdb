//
//  MovieListViewModel.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

import CoreData
import SwiftUI

@MainActor
class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var errorMessage: String?
    @Published var isComplete: Bool = false
    @Published var isError: Bool = false
    var page = 0
    var totalOfPages = 0
    
    func fetchMovies(query: String, viewContext: NSManagedObjectContext, isFromScroll: Bool) async throws {
        self.isComplete = false
        self.isError = false
        
        if !isFromScroll {
            page = 1
            totalOfPages = 0
        }
        
        if page > totalOfPages && totalOfPages > 0 {
            return
        }
        
        do {
            let client = MovieClient(endpoint: .search(query: query, page: String(page)))
            let result: SearchResponse = try await client.performAndDecode()
            
            let favoriteIds = fetchFavoriteMovies(viewContext: viewContext)
            let movies = result.search.map(\.self).map { MovieAdapter.adapt(from: $0, favoriteIds: favoriteIds) }
            
            if !isFromScroll {
                self.movies.removeAll()
            }
            
            self.movies.append(contentsOf: movies)
            
            if totalOfPages == 0, let numberOfRows = Double(result.numberOfRows) {
                totalOfPages = Int(ceil(Double(numberOfRows / 10.0)))
            }
            page += 1
            
            self.isComplete = true
            print("Fetched movie list: \(self.movies)")
        } catch let APIError.apiError(message) {
            print("Api error: \(message)")
            self.isError = true
            self.errorMessage = message
        } catch {
            print("Unexpected error")
            self.isError = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    func fetchFavoriteMovies(viewContext: NSManagedObjectContext) -> Set<String> {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
            
        do {
            let favoriteMovies = try viewContext.fetch(fetchRequest)
            return Set(favoriteMovies.compactMap { $0.imdbId })
        } catch {
            print("Error fetching favorite movies: \(error)")
            return []
        }
    }
}
