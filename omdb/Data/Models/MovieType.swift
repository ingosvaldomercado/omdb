//
//  MovieType.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

enum MovieType: String, Codable {
    case episode
    case game
    case movie
    case series
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = .init(rawValue: rawValue) ?? .unknown
    }
}
