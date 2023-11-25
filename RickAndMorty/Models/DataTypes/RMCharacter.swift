//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 23/11/23.
//

import Foundation

struct RMCharacter: Codable {
  let id: Int
  let name: String
  let status: String
  let species: String
  let type: String
  let gender: RMCharacterGender
  let origin: RMCharacterOrigin
  let location: RMCharacterLocation
  let image: String
  let episode: [String]
  let url: String
  let created: String
}

