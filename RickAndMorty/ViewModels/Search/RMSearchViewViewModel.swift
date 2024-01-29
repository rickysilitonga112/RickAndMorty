//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 05/01/24.
//

import Foundation

// Responsibilities
// - show search results
// - show no results
// - kick off API Request
final class RMSearchViewViewModel {
    public let config: RMSearchViewController.Config
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
}
