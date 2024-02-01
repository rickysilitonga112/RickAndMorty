//
//  RMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 28/01/24.
//

import Foundation

final class RMSearchInputViewViewModel {
    private let config: RMSearchViewController.Config.`Type`
    
    enum DynamicOption: String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
        
        var queryArgument: String {
            switch self {
            case .status:
                return "status"
            case .gender:
                return "gender"
            case .locationType:
                return "type"
            }
        }
        
        var choices: [String] {
            switch self {
            case .status:
                return ["alive", "dead", "unknown"]
            case .gender:
                return ["female", "male", "genderless", "unknown"]
            case .locationType:
                return ["planet", "cluster", "microverse"]
            }
        }
    }
    
    init(config: RMSearchViewController.Config.`Type`){
        self.config = config
    }
    
    // MARK: - public
    public var hasDynamicOption: Bool {
        switch config {
        case .character, .location:
            return true
        case .episode:
            return false
        }
    }

    public var options: [DynamicOption] {
        switch config {
        case .character:
            return [.status, .gender]
        case .location:
            return [.locationType]
        case .episode:
            return []
        }
    }
    
    public var searchTitle: String {
        switch config {
        case .character:
            return "Search Character"
        case .location:
            return "Search Location"
        case .episode:
            return "Search Episode"
        }
    }
}
