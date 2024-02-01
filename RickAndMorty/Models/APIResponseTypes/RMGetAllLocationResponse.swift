//
//  RMGetAllLocationResponse.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 24/01/24.
//

import Foundation

struct RMGetAllLocationResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMLocation]
}
