//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 30/01/24.
//

import Foundation

class RMSearchResultViewModel {
    public private(set) var results: RMSearchResultType
    
    init(results: RMSearchResultType) {
        self.results = results
    }
    
}

enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
