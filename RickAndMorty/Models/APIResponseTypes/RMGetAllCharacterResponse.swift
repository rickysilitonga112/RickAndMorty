//
//  RMGetCharacterResponse.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 25/11/23.
//

import Foundation

struct RMGetAllCharacterResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMCharacter]
}
