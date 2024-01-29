//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 05/01/24.
//

import UIKit

final class RMSearchView: UIView {
    private let viewModel: RMSearchViewViewModel
    
    // MARK: - Subviews
    
    // Search input view
    
    // No results view
    private let noSearchResultsView = RMNoSearchResultsView()
    // results collection view
    
    // MARK: - init
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(noSearchResultsView)
        setupConstraints()
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
        ])
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
