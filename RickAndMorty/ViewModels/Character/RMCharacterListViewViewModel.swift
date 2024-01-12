//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 16/12/23.
//

import Foundation
import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
}

/// Handle all the data and view CharacterListView need 
final class RMCharacterListViewViewModel: NSObject {
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string:character.image)
                )
                
                // checking to avoid repeatitive view models
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    public var apiInfo: RMGetAllCharacterResponse.Info? = nil
    
    /// Fetch initial set of characters (20 characters)
    func fetchCharacters() {
        // execute the service with request
        RMService.shared.execute(.listCharactersRequests, expecting: RMGetAllCharacterResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.characters = results
                
                self?.apiInfo = info
                
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Paginate if additional characters are needed
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacters else {
            return
        }
        
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            // after request set for loading more characters to flase
            isLoadingMoreCharacters = false
            return
        }
        
        // after success with create a request, execute that request
        RMService.shared.execute(request, expecting: RMGetAllCharacterResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                strongSelf.apiInfo = responseModel.info
                
                // count the total of viewModels + new results data aka more characters
                let moreCharactersCount = moreResults.count
                let totalVMCount = strongSelf.characters.count + moreCharactersCount
                
                let startingIndexForIndexPath = totalVMCount - moreCharactersCount
                
                // create the indexpath to resume the collectionView
                let indexPathToAdd: [IndexPath] = Array(startingIndexForIndexPath ..< (startingIndexForIndexPath+moreCharactersCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.characters.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters(with: indexPathToAdd)
                    strongSelf.isLoadingMoreCharacters = false
                }
            case .failure(let error):
                print(String(describing: error))
                self?.isLoadingMoreCharacters = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as?
                RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        cell.configure(with: cellViewModels[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width , height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelectCharacter(characters[indexPath.row])
    }
    
    
    // MARK: - FOOTER SPINNER
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsopported")
        }
        
        footer.startAnimating()
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

// MARK: - SCROLL VIEW DELEGATE
extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("Offset: \(offset)")
//        print("totalContentHeight: \(totalContentHeight)")
//        print("totalScrollViewFixedHeight: \(totalScrollViewFixedHeight)")
        
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextURLString = apiInfo?.next,
              let url = URL(string: nextURLString) else {
            return
        }
        
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

        /// this code to fix redundant fetching a more character
        guard offset > 0 else {
            return
        }
        
        if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
//            print("Total: \(totalContentHeight - totalScrollViewFixedHeight)")
//            print("Next URL String: \(nextURLString)")
            print("Load more characters with url : \(url)")
            fetchAdditionalCharacters(url: url)
        }
    }
    
}
