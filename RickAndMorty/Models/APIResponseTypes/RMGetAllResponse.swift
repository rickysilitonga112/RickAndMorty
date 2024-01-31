//
//  RMGetAllResponse.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 30/01/24.
//

import Foundation

struct RMGetAllResponses<T: Codable>: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [T]
}
