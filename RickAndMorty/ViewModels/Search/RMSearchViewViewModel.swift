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
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var optionUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    private var searchText = ""
    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
    private var noResultsHandler: (() -> Void)?
    private var searchResultModel: Codable?
    
    // MARK: - init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - private
    private func makeSearchApiCall<T: Codable>(_ request: RMRequest, type: T.Type) {
        RMService.shared.execute(request, expecting: type) {[weak self] result in
            switch result {
            case .success(let model):
                self?.processSearchResult(model: model)
                
            case .failure(_):
                self?.handleNoResult()
            }
        }
    }
    
    private func handleNoResult() {
        noResultsHandler?()
    }
    
    private func processSearchResult(model: Codable) {
        var resultsVM: RMSearchResultType?
        if let characterResults = model as? RMGetAllCharacterResponse {
            resultsVM = .characters(characterResults.results.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.url))
            }))
        } else if let episodeResults = model as? RMGetAllEpisodeResponse {
            resultsVM = .episodes(episodeResults.results.compactMap({ episode in
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: episode.url))
            }))
            
        } else if let locationResults = model as? RMGetAllLocationResponse {
            self.searchResultModel = model
            resultsVM = .locations(locationResults.results.compactMap({ location in
                return RMLocationTableViewCellViewModel(location: location)
            }))
        } else {
            handleNoResult()
        }
        
        if let results = resultsVM {
            self.searchResultModel = model
            let vm = RMSearchResultViewModel(results: results)
            self.searchResultHandler?(vm)
        }
    }
    
    // MARK: - public
    public func locationSearchResult(at index: Int) -> RMLocation? {
        guard let searchModel = searchResultModel as? RMGetAllLocationResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionUpdateBlock?(tuple)
    }
    
    public func executeSearch() {
        // Build query item
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        
        // add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap { _, element in
            return URLQueryItem(name: element.key.queryArgument, value: element.value)
        })
        
        // create request
        let request = RMRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )
        
        switch config.type.endpoint {
        case .character:
            makeSearchApiCall(request, type: RMGetAllCharacterResponse.self)
        case .location:
            makeSearchApiCall(request, type: RMGetAllLocationResponse.self)
        case .episode:
            makeSearchApiCall(request, type: RMGetAllEpisodeResponse.self)
        }
    }
    
    // handler
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }
    
    public func registerOptionChangeBlock(
        _ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void
    ) {
        self.optionUpdateBlock = block
    }
    
    public func registerNoResultsHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }
}
