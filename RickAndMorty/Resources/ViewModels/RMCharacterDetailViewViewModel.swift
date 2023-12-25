//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 19/12/23.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        return character.name.uppercased()
    }
}
