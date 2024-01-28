//
//  RMLocationViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 24/01/24.
//

import Foundation

protocol RMLocationViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

class RMLocationViewModel {
    weak var delegate: RMLocationViewModelDelegate?
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    private var hasMoreResults: Bool {
        return false
    }
    private var apiInfo: RMGetAllLocationResponse.Info?
    
    init() {}
    
    public func location(at index: Int) -> RMLocation? {
        print("Debug: Index - \(index)")
        print("Debug: Locations count - \(locations.count)")
        guard index < locations.count, index >= 0 else {
            return nil
        }
        
        return locations[index]
    }
    
    public func fetchLocations() {
        RMService.shared.execute(.listLocationsRequest, expecting: RMGetAllLocationResponse.self) {[weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
}
