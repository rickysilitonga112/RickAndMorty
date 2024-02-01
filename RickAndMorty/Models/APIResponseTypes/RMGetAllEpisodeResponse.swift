//
//  RMGetAllEpisodeResponse.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 01/01/24.
//

import Foundation

struct RMGetAllEpisodeResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMEpisode]
}
