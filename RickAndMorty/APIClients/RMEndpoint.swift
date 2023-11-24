//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 21/11/23.
//

import Foundation

/// Represent unique API Endpoint
@frozen enum RMEndpoint: String {
    /// endpoint to get character
    case character
    /// endpoint to get location
    case location
    /// endpoint to get episode
    case episode
}
