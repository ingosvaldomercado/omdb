//
//  SearchResponse.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

struct SearchResponse: Codable {
    let search: [MovieResponse]
    let numberOfRows: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case numberOfRows = "totalResults"
    }
}
