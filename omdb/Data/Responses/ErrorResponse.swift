//
//  ErrorResponse.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

struct ErrorResponse: Codable {
    var response: String
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case message = "Error"
    }
}
