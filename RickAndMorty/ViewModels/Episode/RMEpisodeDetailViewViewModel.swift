//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 31/12/23.
//

import Foundation

final class RMEpisodeDetailViewViewModel {
    private let endpointUrl: URL?
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData()
    }
    
    private func fetchEpisodeData() {
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) {[weak self] result in
            switch result {
            case .success(let dataModel):
                print(String(describing: dataModel))
            case .failure(let failure):
                print("Filure with code: \(failure)")
            }
        }
    }
}
