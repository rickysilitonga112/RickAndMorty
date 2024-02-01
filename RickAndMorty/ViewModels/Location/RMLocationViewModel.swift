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
    public var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    private var hasMoreResults: Bool {
        return false
    }
    private var didFinishPagination: (() -> Void)?
    private var apiInfo: RMGetAllLocationResponse.Info?
    public var isLoadingMoreLocations = false
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
  
    // MARK: - Init
    init() {}
    
    // MARK: - Public
    
    public func registerDidFinishPagination(_ block: @escaping () -> Void) {
        self.didFinishPagination = block
    }
    
    public func fetchMoreLocations() {
        guard !isLoadingMoreLocations else { return }
        
        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreLocations = true
        guard let request = RMRequest(url: url) else {
            // after request set for loading more characters to flase
            isLoadingMoreLocations = false
            return
        }
        
        // after success with create a request, execute that request
        RMService.shared.execute(request, expecting: RMGetAllLocationResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                strongSelf.apiInfo = responseModel.info
//                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({ location in
//                    return RMLocationTableViewCellViewModel(location: location)
//                }))
                strongSelf.locations.append(contentsOf: moreResults.compactMap({ location in
                    return location
                }))
                
//                strongSelf.locations.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreLocations = false
                    
                    // notify the callback
                    strongSelf.didFinishPagination?()
                }
            case .failure(let error):
                print(String(describing: error))
                self?.isLoadingMoreLocations = false
            }
        }
    }
    
    public func location(at index: Int) -> RMLocation? {
        print("Debug: Index - \(index)")
        print("Debug: Locations count - \(locations.count)")
        guard index < locations.count, index >= 0 else {
            return nil
        }
        
        return self.locations[index]
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
