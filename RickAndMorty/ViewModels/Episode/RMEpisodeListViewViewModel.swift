//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 01/01/24.
//

import Foundation
import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
}

/// Handle all the data and view EpisodeListView need
final class RMEpisodeListViewViewModel: NSObject {
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreEpisode = false
    
    private let borderColors: [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemYellow,
        .systemIndigo,
        .systemMint
    ]
    
    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url),
                    borderColor: borderColors.randomElement() ?? .systemBlue
                )
                
                // append the cell view models if there is no duplicate viewmodels
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    
    public var apiInfo: RMGetAllEpisodeResponse.Info? = nil
    
    /// Fetch initial set of characters (20 characters)
    func fetchEpisodes() {
        // execute the service with request
        RMService.shared.execute(.listEpisodeRequests, expecting: RMGetAllEpisodeResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.episodes = results
                
                self?.apiInfo = info
                
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
                fatalError("Failed to get episode response..")
            }
        }
    }
    
    /// Paginate if additional characters are needed
    public func fetchAdditionalEpisode(url: URL) {
//        print("DEBUG: isLoadingMoreEpisode: \(isLoadingMoreEpisode)")
        guard !isLoadingMoreEpisode else {
            return
        }
        
        isLoadingMoreEpisode = true
        guard let request = RMRequest(url: url) else {
            // after request set for loading more characters to flase
            isLoadingMoreEpisode = false
            return
        }
        
        // after success with create a request, execute that request
        RMService.shared.execute(request, expecting: RMGetAllEpisodeResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                strongSelf.apiInfo = responseModel.info
                
                // count the total of viewModels + new results data aka more characters
                let moreEpisodesCount = moreResults.count
                let totalVMCount = strongSelf.episodes.count + moreEpisodesCount
                
                let startingIndexForIndexPath = totalVMCount - moreEpisodesCount
                
                // create the indexpath to resume the collectionView
                let indexPathToAdd: [IndexPath] = Array(startingIndexForIndexPath ..< (startingIndexForIndexPath+moreEpisodesCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.episodes.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisodes(with: indexPathToAdd)
                    strongSelf.isLoadingMoreEpisode = false
                }
            case .failure(let error):
                print(String(describing: error))
                self?.isLoadingMoreEpisode = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as?
                RMCharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        cell.configure(with: cellViewModels[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = bounds.width - 20
        return CGSize(width: width , height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
//        delegate?.didSelectCharacter(characters[indexPath.row])
        let selection = episodes[indexPath.row]
        delegate?.didSelectEpisode(selection)
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
        
        return CGSize(
            width: collectionView.frame.width,
            height: 100
        )
    }
}

// MARK: - SCROLL VIEW DELEGATE
extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreEpisode,
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
//            print("Load more Episode with url : \(url)")
            fetchAdditionalEpisode(url: url)
        }
    }
    
}
