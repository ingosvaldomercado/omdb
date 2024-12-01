//
//  ConfigManager.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

import Foundation

// MARK: - Configuration Manager Type
protocol ConfigManagerType {
    func getConfig(with key: ConfigKeys, env: Host?) -> String?
}

// MARK: - ConfigManager Manager
class ConfigManager: ConfigManagerType {
    // MARK: - Shared Instance
    static let shared: ConfigManagerType = ConfigManager()
    
    // MARK: - Functionality
    func getConfig(with key: ConfigKeys, env: Host?) -> String? {
        if let env, let dictionary = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? [String: String] {
            return dictionary[env.rawValue]
        }
        
        return Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String
    }
}

extension ConfigManagerType {
    
    func getConfig(with key: ConfigKeys, environment: Host? = nil) -> String? {
        getConfig(with: key, env: environment)
    }
}

// MARK: - Configuration Keys
enum ConfigKeys: String {
    case apiKey = "API_KEY"
    case apiBaseURL = "API_BASE_URL_KEY"
}

