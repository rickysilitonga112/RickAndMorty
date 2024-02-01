//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 05/01/24.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation)
    
    func rmSearchView(_ searchView: RMSearchView, didSelectCharcter character: RMCharacter)
    
    func rmSearchView(_ searchView: RMSearchView, didSelectEpisode episode: RMEpisode)
}

final class RMSearchView: UIView {
    weak var delegate: RMSearchViewDelegate?
    
    private let viewModel: RMSearchViewViewModel
    
    // MARK: - Subviews
    
    // Search input view
    private let searchInputView = RMSearchInputView()
    // No results view
    private let noSearchResultsView = RMNoSearchResultsView()
    // results collection view
    private let searchResultView = RMSearchResultView()
    
    // MARK: - init
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(searchResultView, noSearchResultsView, searchInputView)
        searchInputView.configure(with: RMSearchInputViewViewModel(config: viewModel.config.type))
        searchInputView.delegate = self
        searchResultView.delegate = self
        setupConstraints()
        
        setupHandler(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // No results
            noSearchResultsView.widthAnchor.constraint(equalToConstant: 150),
            noSearchResultsView.heightAnchor.constraint(equalToConstant: 150),
            noSearchResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noSearchResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
           
            searchResultView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            searchResultView.leftAnchor.constraint(equalTo: leftAnchor),
            searchResultView.rightAnchor.constraint(equalTo: rightAnchor),
            searchResultView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 50 : 110),
        ])
    }
    
    private func setupHandler( viewModel: RMSearchViewViewModel) {
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultHandler {[weak self] result in
            DispatchQueue.main.async {
                self?.searchResultView.configure(with: result)
                self?.noSearchResultsView.isHidden = true
                self?.searchResultView.isHidden = false
            }
        }
        
        viewModel.registerNoResultsHandler {[weak self] in
            DispatchQueue.main.async {
                self?.noSearchResultsView.isHidden = false
                self?.searchResultView.isHidden = true
            }
        }
    }
    
    public func setupKeyboard() {
        searchInputView.presentKeyboard()
    }
        
}

// MARK: - CollectionView Delegate and Datasource
extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - RMSearchInputViewDelegate
extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputView(_ searchInputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
    
    func rmSearchInputView(_ searchInputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputViewSearchButtonClicked(_ searchInputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
}

// MARK: - RMSearchResultViewDelegate
extension RMSearchView: RMSearchResultViewDelegate {
    func rmSearchResultView(_ resultView: RMSearchResultView, didTapCharacterAt index: Int) {
        guard let character = viewModel.characterSearchResult(at: index) else {
            return
        }
        self.delegate?.rmSearchView(self, didSelectCharcter: character)
    }
    func rmSearchResultView(_ resultView: RMSearchResultView, didTapEpisodeAt index: Int) {
        guard let episode = viewModel.episodeSearchResult(at: index) else {
            return
        }
        self.delegate?.rmSearchView(self, didSelectEpisode: episode)
    }
    
    func rmSearchResultView(_ resultView: RMSearchResultView, didTapLocationAt index: Int) {
        guard let location = viewModel.locationSearchResult(at: index) else {
            return
        }
        self.delegate?.rmSearchView(self, didSelectLocation: location)
    }
}
