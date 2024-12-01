//
//  Endpoint.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

import Foundation

protocol Endpoint {
    var _protocol: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var contentType: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var baseUrlString: String { get }
    var basePath: String { get }
    
    func host() -> Host
    func body() throws -> Data?
}

enum Host: String {
    case development
    case production
}

enum OMDBEndpoint: Endpoint {
    case search(query: String, page: String)
    case detail(id: String)
    
    var _protocol: String {
        return "https"
    }
    
    var path: String {
        switch self {
        case .search, .detail: return ""
        }
    }
    
    var method: String {
        switch self {
        case .search, .detail: return "GET"
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var contentType: String? {
        switch self {
        case .search, .detail: return "application/json; charset=utf-8"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .search(query: query, page: page):
            return [
                .init(name: "apikey", value: ConfigManager.shared.getConfig(with: .apiKey)),
                .init(name: "s", value: query),
                .init(name: "page", value: page)
            ]
        case let .detail(id: id):
            return [
                .init(name: "i", value: id),
                .init(name: "apikey", value: ConfigManager.shared.getConfig(with: .apiKey)),
                .init(name: "plot", value: "full")
            ]
        }
    }
    
    var baseUrlString: String {
        switch host() {
        case .development:
            return "\(_protocol)://\(ConfigManager.shared.getConfig(with: .apiBaseURL, environment: .development) ?? String())"
        case .production:
            return "\(_protocol)://\(ConfigManager.shared.getConfig(with: .apiBaseURL, environment: .production) ?? String())"
        }
    }
    
    var basePath: String {
        return "/"
    }
    
    func host() -> Host {
        #if DEBUG
            return .development
        #else
            return .production
        #endif
    }
    
    func body() throws -> Data? {
        return nil
    }
}
