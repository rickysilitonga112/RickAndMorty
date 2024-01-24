//
//  RMLocationViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 24/01/24.
//

import Foundation

struct RMLocationViewModel {
    private var locations: [RMLocation] = []
    
    private var cellViewModels: [String] = []
    
    private var hasMoreResults: Bool {
        return false
    }

    
    init() {
    }
    
    public func fetchLocation() {
        RMService.shared.execute(.listLocationsRequest, expecting: String.self) { result in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
}
