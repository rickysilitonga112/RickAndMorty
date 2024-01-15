//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 31/12/23.
//

import Foundation

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {
    private let endpointUrl: URL?
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    private var dataTuple: (episode: RMEpisode,characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            self.delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
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

        let episode = dataTuple.episode
        let characters = dataTuple.characters

        var createdString = episode.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
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
    
    private func fetchRelatedCharacters(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters.compactMap { url in
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
            self.dataTuple = (episode: episode,characters: characters)
        }
    }
    
    // MARK: - PUBLIC
    
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        
        return dataTuple.characters[index]
    }
    
    /// Fetch backing episode model
    /// called from the view controller
    public func fetchEpisodeData() {
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) {[weak self] result in
            switch result {
            case .success(let dataModel):
                self?.fetchRelatedCharacters(episode: dataModel)
            case .failure(let failure):
                print("Filure with code: \(failure)")
            }
        }
    }
}
