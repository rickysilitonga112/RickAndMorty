//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 16/12/23.
//

import Foundation
import UIKit

final class RMCharacterListViewViewModel: NSObject {
    func fetchCharacter() {
        // execute the service with request
        RMService.shared.execute(.listCharactersRequests, expecting: RMGetAllCharacterResponse.self) { result in
            switch result {
            case .success(let model):
                print("DEBUG - Total info count: \(model.info.count)")
                print("DEBUG - Total info pages: \(model.info.pages)")
                print("DEBUG - Page results count: \(model.results.count)")
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as?
                RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        let viewModel = RMCharacterCollectionViewCellViewModel(characterName: "Rick",
                                                               characterStatus: .alive,
                                                               characterImageUrl: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width , height: width * 1.5)
    }
}
