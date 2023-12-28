//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 21/11/23.
//

import Foundation


/// Object that represents a single API call
final class RMRequest {
    
    /// API related constants
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    /// Desired endpoint
    private let endpoint: RMEndpoint
    
    /// Path components for API, if any
    private let pathComponents: [String]
    
    /// Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url string for the api request in string format
    public var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            
            // compact map used to filter out the nil value
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    /// Computed and constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    // MARK: - PUBLIC Init
    public let httpMethod = "GET"
    
    /// Constructed request
    /// - Parameters:
    ///   - endpoint: Target endopoint
    ///   - pathComponents: Collection of path components
    ///   - queryParameters: Collection of query parameters
    public init(endpoint: RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        
        // base url: "https://rickandmortyapi.com/api"
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "/", with: "")
        
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
//
                let endpointString = components[0] //endpoint
                var pathComponents: [String] = []
                
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst() // remove the endpoint
                }
                
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
            
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
//                print("RMRequest - PathComponennts: \(components)")
                // RESULT of PRINT: RMRequest - PathComponennts: ["character", "page=2"]
                let endpointString = components[0]
                let queryItemsString = components[1]
                
                let questyItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else { return nil }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                
                // create endpoint
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameters: questyItems)
                    return 
                }
            }
        }
        return nil
    }
}


extension RMRequest {
    // to improve readablity of the code
    static let listCharactersRequests = RMRequest(endpoint: .character)
    
    // create for all request for example get locations
}
