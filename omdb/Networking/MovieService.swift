//
//  APIService.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

import Foundation

protocol APIServiceLogic {
    func performAndDecode<Model: Decodable>() async throws -> Model
}

enum APIError: Error {
    case unknown
    case invalidRequest
    case apiError(message: String)
    case parsingError
    case baseURLInvalid
    case timeOut
    case noConnection
    case hostUnreachable
    case expiredSession
    case serverError(response: HTTPURLResponse)
}

typealias MovieClient = MovieService<OMDBEndpoint>

struct MovieService<Endpoints: Endpoint>: APIServiceLogic {
    private let host: Host
    private let endpoint: Endpoints
    
    init(endpoint: Endpoints) {
        self.host = endpoint.host()
        self.endpoint = endpoint
    }
    
    private var url: URL? {
        guard var components = URLComponents(string: endpoint.baseUrlString) else {
            fatalError("Could not iniate URLComponents: wrong base url")
        }
        
        components.path = endpoint.basePath + endpoint.path
        components.queryItems = endpoint.queryItems
        return components.url
    }
    
    func performAndDecode<Model: Decodable>() async throws -> Model {
        let (data, _) = try await perform()
        
        do {
            let result = try JSONDecoder().decode(Model.self, from: data)
            return result
        } catch {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.apiError(message: errorResponse.message)
            } else {
                print("Parsing error")
                throw APIError.parsingError
            }
        }
    }
    
    private func request() throws -> URLRequest? {
        guard let url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.httpBody = try endpoint.body()
        request.cachePolicy = .returnCacheDataElseLoad
        if let contentType = endpoint.contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        if let headers = endpoint.headers {
            headers.forEach { (key, value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
    
    private func perform() async throws -> (Data, URLResponse) {
        guard let request = try request() else {
            throw APIError.invalidRequest
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300:
                    print("Successful request")
                case 440:
                    print("Expired session")
                    throw APIError.expiredSession
                default:
                    throw APIError.serverError(response: httpResponse)
                }
            }
            return (data, response)
        } catch {
            if let urlError = error as? URLError {
                switch urlError.code {
                    case .timedOut:
                        print("Request time out")
                        throw APIError.timeOut
                    case .badServerResponse:
                        print("Wrong server response")
                        throw APIError.baseURLInvalid
                    case .badURL:
                        print("Request time out")
                        throw APIError.baseURLInvalid
                    case .notConnectedToInternet:
                        print("No Internet connectinon")
                        throw APIError.noConnection
                    case .cannotFindHost:
                        print("No server found")
                        throw APIError.hostUnreachable
                default:
                    print("Unknown server error")
                    throw APIError.unknown
                }
            } else {
                print("Unexpected error")
                throw APIError.unknown
            }
        }
    }
}
