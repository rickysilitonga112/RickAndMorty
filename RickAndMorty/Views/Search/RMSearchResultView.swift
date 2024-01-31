//
//  RMSearchResultView.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 30/01/24.
//

import UIKit

protocol RMSearchResultViewDelegate: AnyObject {
    func rmSearchResultView(_ resultView: RMSearchResultView, didTapLocationAt index: Int)
}

/// Shows search results UI (table or collection as needed)
final class RMSearchResultView: UIView {
    weak var delegate: RMSearchResultViewDelegate?
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            processViewModel()
        }
    }
    
    private var locationTableViewCellViewModels: [RMLocationTableViewCellViewModel] = []
    
    private var collectionViewCellViewModels: [any Hashable] = []
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RMLocationTableViewCell.self,
                           forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        
        return tableView
    }()
    
    /// collection view
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
         
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // register the collection view cell that used in RMSearchResultView
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        
        // register the collection view cell that used in RMSearchResultView
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        
        // register the loading spinner when load data in footer that used in RMSearchResultView
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        
        
        return collectionView
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        
        addSubviews(tableView, collectionView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        switch viewModel.results {
        case .characters(let viewModels):
            print(String(describing: viewModels))
            self.collectionViewCellViewModels = viewModels
            setupCollectionView()
        case .episodes(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setupCollectionView()
        case .locations(let viewModels):
            setupTableView(viewModels: viewModels)
        }
    }
    
    private func setupCollectionView() {
        self.tableView.isHidden = true
        self.collectionView.isHidden = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }

    private func setupTableView(viewModels: [RMLocationTableViewCellViewModel]) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        collectionView.isHidden = true
        self.locationTableViewCellViewModels = viewModels
        tableView.reloadData()
    }

    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: - Public
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - TableView Delegate & DataSource
extension RMSearchResultView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("Debug - TableViewCount: \(locationTableViewCellViewModels.count)")
        return locationTableViewCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier, for: indexPath) as? RMLocationTableViewCell else {
            fatalError("Unable to create loacation table view cell")
        }
        cell.configure(with: locationTableViewCellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.rmSearchResultView(self, didTapLocationAt: indexPath.row)
    }
}

// MARK: - CollectionView Delegate & DataSource
extension RMSearchResultView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        if let characterVM = currentViewModel as? RMCharacterCollectionViewCellViewModel {
            // Character cell
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: characterVM)
            return cell
        }

        // Episode
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError()
        }
        if let episodeVM = currentViewModel as? RMCharacterEpisodeCollectionViewCellViewModel {
            cell.configure(with: episodeVM)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // TODO: Handle change screen
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]

        let bounds = collectionView.bounds

        if currentViewModel is RMCharacterCollectionViewCellViewModel {
            // Character size
            let width = UIDevice.isiPhone ? (bounds.width-30)/2 : (bounds.width-50)/4
            return CGSize(
                width: width,
                height: width * 1.5
            )
        }

        // Episode
        let width = UIDevice.isiPhone ? bounds.width-20 : (bounds.width-50) / 4
        return CGSize(
            width: width,
            height: 100
        )
    }
}



extension UIDevice {
    /// Check if current device is phone idiom
    static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
}
