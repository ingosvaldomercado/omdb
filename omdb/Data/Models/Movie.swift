//
//  Movie.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

import Foundation

struct Movie: Equatable, Identifiable {
    let id = UUID()
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
    var isFavorite: Bool = false
    
    static func sampleData() -> Movie {
        return Movie(title: "The Walking Dead",
                     year: "2010–2022",
                     imdbID: "tt1520211",
                     type: .series,
                     poster: "https://m.media-amazon.com/images/M/MV5BYWQwMGRhNGEtZTNhMy00MzVjLWJhMjItYjcwMDljMTkyNTg2XkEyXkFqcGc@._V1_SX300.jpg",
                     rated: "TV-MA",
                     released: "31 Oct 2010",
                     genre: "Drama, Horror, Thriller",
                     director: "N/A",
                     actors: "Andrew Lincoln, Norman Reedus, Melissa McBride",
                     plot: "Sheriff Deputy Rick Grimes gets shot and falls into a coma. When awoken he finds himself in a Zombie Apocalypse. Not knowing what to do he sets out to find his family, after he's done that, he gets connected to a group to become the leader. He takes charge and tries to help this group of people survive, find a place to live and get them food. This show is all about survival, the risks and the things you'll have to do to survive.",
                     language: "English",
                     country: "United States",
                     awards: "Won 2 Primetime Emmys. 85 wins & 239 nominations total",
                     ratings: Ratings(source: "Internet Movie Database",
                                      value: "8.1/10"),
                     imdbRating: "8.1",
                     imdbVotes: "1,114,383",
                     totalSeasons: "11",
                     isFavorite: false)
    }
}

/*{
  "Title": "The Walking Dead",
  "Year": "2010–2022",
  "Rated": "TV-MA",
  "Released": "31 Oct 2010",
  "Runtime": "44 min",
  "Genre": "Drama, Horror, Thriller",
  "Director": "N/A",
  "Writer": "Frank Darabont",
  "Actors": "Andrew Lincoln, Norman Reedus, Melissa McBride",
  "Plot": "Sheriff Deputy Rick Grimes gets shot and falls into a coma. When awoken he finds himself in a Zombie Apocalypse. Not knowing what to do he sets out to find his family, after he's done that, he gets connected to a group to become the leader. He takes charge and tries to help this group of people survive, find a place to live and get them food. This show is all about survival, the risks and the things you'll have to do to survive.",
  "Language": "English",
  "Country": "United States",
  "Awards": "Won 2 Primetime Emmys. 85 wins & 239 nominations total",
  "Poster": "https://m.media-amazon.com/images/M/MV5BYWQwMGRhNGEtZTNhMy00MzVjLWJhMjItYjcwMDljMTkyNTg2XkEyXkFqcGc@._V1_SX300.jpg",
  "Ratings": [
    {
      "Source": "Internet Movie Database",
      "Value": "8.1/10"
    }
  ],
  "Metascore": "N/A",
  "imdbRating": "8.1",
  "imdbVotes": "1,114,383",
  "imdbID": "tt1520211",
  "Type": "series",
  "totalSeasons": "11",
  "Response": "True"
}*/
