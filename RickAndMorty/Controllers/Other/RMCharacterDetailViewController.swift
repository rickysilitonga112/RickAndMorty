//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 19/12/23.
//

import UIKit

class RMCharacterDetailViewController: UIViewController {
    private let viewModel: RMCharacterDetailViewViewModel
    private let detailView: RMCharacterDetailView
    
    // MARK: - init
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel )
        super.init(nibName: nil, bundle: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        view.addSubview(detailView)
        print(String(describing: viewModel))
        
        addConstraints()
        
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = viewModel.title
    }
    
    @objc
    private func didTapShare() {
        // Share character info
        print("Controller: - Share button pressed...")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - Collection View Delegate and Data Source
extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    ///for how much section on a collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    
    /// for how much items in every section in a collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        
        switch sectionType {
        case .photo:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterPhotoCollectionViewCell.identifier,
                for: indexPath
            ) as? RMCharacterPhotoCollectionViewCell else {
                fatalError("Failed to cast cell to RMCharacterPhotoCollectionViewCell")
            }
            cell.backgroundColor = .systemPink
            return cell
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterInfoCollectionViewCell.identifier,
                for: indexPath
            ) as? RMCharacterInfoCollectionViewCell else {
                fatalError("Failed to cast cell to RMCharacterInfoCollectionViewCell")
            }
            
            cell.backgroundColor = .systemBlue
            return cell
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier,
                for: indexPath
            ) as? RMCharacterEpisodeCollectionViewCell else {
                fatalError("Failed to cast cell to RMCharacterEpisodeCollectionViewCell")
            }
            
            cell.backgroundColor = .systemRed
            return cell
        }
    }
}
