//
//  RMService.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 21/11/23.
//

import Foundation

/// Primary API Service object to get Rick and Morty data
final class RMService {
    
    
    /// Shared singleton instance
    static let shared = RMService()
    
    
    /// Personalized constructor
    private init() {}
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request Instance
    ///   - completion: Callback with data or error
    public func execute(_ request: RMRequest, completion: @escaping () -> Void) {
        
    }
}
