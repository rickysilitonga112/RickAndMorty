//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 24/01/24.
//

import Foundation

struct RMLocationTableViewCellViewModel {
    private let location: RMLocation
    
    init(location: RMLocation) {
        self.location = location
    }
    
    public var name: String {
        return location.name
    }
    
    public var type: String {
        return location.type
    }
    
    public var dimension: String {
        return location.dimension
    }
}

extension RMLocationTableViewCellViewModel: Hashable, Equatable {
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(location.id)
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(dimension)
    }
}
