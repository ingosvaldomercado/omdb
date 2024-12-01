//
//  MovieAdapter.swift
//  omdb
//
//  Created by Osvaldo Mercado on 1/12/24.
//

import Foundation

struct MovieAdapter {
    
    static func adapt(from response: MovieResponse, favoriteIds: Set<String>) -> Movie {
        return Movie(
            title: response.title,
            year: response.year,
            imdbID: response.imdbID,
            type: response.type,
            poster: response.poster,
            rated: response.rated,
            released: response.released,
            genre: response.rated,
            director: response.imdbVotes,
            actors: response.actors,
            plot: response.plot,
            language: response.language,
            country: response.country,
            awards: response.awards,
            ratings: response.ratings,
            imdbRating: response.imdbRating,
            imdbVotes: response.imdbVotes,
            totalSeasons: response.totalSeasons,
            isFavorite: favoriteIds.contains(response.imdbID)
        )
    }
}
