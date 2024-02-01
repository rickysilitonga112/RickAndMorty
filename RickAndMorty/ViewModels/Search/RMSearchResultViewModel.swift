//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 30/01/24.
//

import Foundation

class RMSearchResultViewModel {
    public private(set) var results: RMSearchResultType
    public var next: String?
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    public private(set) var isLoadingMoreResults = false
    
    // MARK: - init
    init(results: RMSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }
    
    /// Fetch additional locations based on the next url
    /// - Parameter completion: callback with array of RMLocationTableViewCellViewModel
    public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else { return }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        RMService.shared.execute(request, expecting: RMGetAllLocationResponse.self) { [weak self] results in
            guard let strongSelf = self else { return }
            
            switch results {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                
                strongSelf.next = info.next // capture new pagination
                
                let additionalResults = moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                })
                
                var newResults: [RMLocationTableViewCellViewModel] = []
                
                switch strongSelf.results {
                case .locations(let existingResults):
                    newResults = existingResults + additionalResults
                    strongSelf.results = .locations(newResults)
                    
                    // notify via completion handler
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        completion(newResults)
                    }
                case .characters, .episodes:
                    break
                }
                
            case .failure(let error):
                print(String(describing: error.localizedDescription))
                strongSelf.isLoadingMoreResults = false
            }
        }
    }
    
    public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
        guard !isLoadingMoreResults else { return }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        print("Next url string, called from vm: \(nextUrlString)")
        isLoadingMoreResults = true
        // create request
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        // switch the result, to kwnow the type
        switch results {
        case .characters(let existingResults):
            RMService.shared.execute(request, expecting: RMGetAllCharacterResponse.self) { [weak self] result in
                switch result {
                case .success(let responseModel):
                    guard let strongSelf = self else { return }
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    
                    strongSelf.next = info.next
                    let additionalResults = moreResults.compactMap { character in
                        return RMCharacterCollectionViewCellViewModel(
                            characterName: character.name,
                            characterStatus: character.status,
                            characterImageUrl: URL(string: character.image)
                        )
                    }
                    
                    let newResults = existingResults + additionalResults
                    strongSelf.results = .characters(newResults)
                   
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        
                        // notify the searchViewModel via callback
                        completion(newResults)
                    }
                    
                case .failure(let error):
                    print(String(describing: error.localizedDescription))
                    self?.isLoadingMoreResults = false
                }
            }
        case .episodes(let existingResults):
            RMService.shared.execute(request, expecting: RMGetAllEpisodeResponse.self) { [weak self] result in
                switch result {
                case .success(let responseModel):
                    guard let strongSelf = self else { return }
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    
                    strongSelf.next = info.next
                    let additionalResults = moreResults.compactMap { episode in
                        return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl:  URL(string: episode.url))
                    }
                    
                    let newResults = existingResults + additionalResults
                    strongSelf.results = .episodes(newResults)
                    
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        
                        // notify the searchViewModel via callback
                        completion(newResults)
                    }
                    
                case .failure(let error):
                    print(String(describing: error.localizedDescription))
                    self?.isLoadingMoreResults = false
                }
            }
        case .locations:
            // handle by fetchAdditionalLocations
            break
        }
    }
    
}

enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
