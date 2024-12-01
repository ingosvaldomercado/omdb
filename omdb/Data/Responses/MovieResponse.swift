//
//  MovieResponse.swift
//  omdb
//
//  Created by Osvaldo Mercado on 1/12/24.
//

struct MovieResponse: Codable {
    let title: String
    let year: String
    let imdbID: String
    let type: MovieType
    let poster: String?
    let rated: String?
    let released: String?
    let genre: String?
    let director: String?
    let actors: String?
    let plot: String?
    let language: String?
    let country: String?
    let awards: String?
    let ratings: Ratings?
    let imdbRating: String?
    let imdbVotes: String?
    let totalSeasons: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
        case rated = "Rated"
        case released = "Released"
        case genre = "Genre"
        case director = "Director"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case ratings
        case imdbRating
        case imdbVotes
        case totalSeasons
    }
}

struct Ratings: Codable, Equatable {
    let source: String
    let value: String
}
