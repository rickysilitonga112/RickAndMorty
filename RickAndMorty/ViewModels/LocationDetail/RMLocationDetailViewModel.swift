//
//  RMLocationDetailViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 28/01/24.
//

import Foundation

protocol RMLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class RMLocationDetailViewViewModel {
    private let endpointUrl: URL?
    public weak var delegate: RMLocationDetailViewViewModelDelegate?
    private var dataTuple: (location: RMLocation,characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            self.delegate?.didFetchLocationDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMLocationInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public private(set) var cellViewModels: [SectionType] = []
        
    // MARK: - Init
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    // MARK: - PRIVATE
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {
            return
        }

        let location = dataTuple.location
        let characters = dataTuple.characters

        var createdString = location.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Created", value: createdString),
            ]),
            .characters(viewModel: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
            }))
        ]
    }
    
    private func fetchRelatedCharacters(location: RMLocation) {
        let requests: [RMRequest] = location.residents.compactMap { url in
            return URL(string: url)
        }.compactMap { url in
            return RMRequest(url: url)
        }
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        
        for request in requests {
            group.enter()
            
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                // defer used to define a block of code that is executed just before the current scope is exited
                defer {
                    group.leave()
                }
                switch result {
                case .success(let dataModel):
                    characters.append(dataModel)
                case .failure:
                    // if the request fail, continue the iteration
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
//            print(characters)
            self.dataTuple = (location: location, characters: characters)
        }
    }
    
    // MARK: - PUBLIC
    
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        
        return dataTuple.characters[index]
    }
    
    /// Fetch backing location model
    /// called from the view controller
    public func fetchLocationData() {
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMLocation.self) {[weak self] result in
            switch result {
            case .success(let dataModel):
                self?.fetchRelatedCharacters(location: dataModel)
            case .failure(let failure):
                print("Filure with code: \(failure)")
            }
        }
    }
}
