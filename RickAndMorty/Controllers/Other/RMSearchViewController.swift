//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 05/01/24.
//

import UIKit

/// Configurable controller to search
final class RMSearchViewController: UIViewController {
    // MARK: - config
    
    struct Config {
        enum `Type` {
            case character
            case episode
            case location
            
            var endpoint: RMEndpoint {
                switch self {
                case .character:
                    return .character
                case .episode:
                    return .episode
                case .location:
                    return .location
                }
            }
            
            var title: String {
                switch self {
                case .character:
                    return "Search character"
                case .episode:
                    return "Search episode"
                case.location:
                    return "Search location"
                }
                
            }
        }
        let type: `Type`
    }

    private let searchView: RMSearchView
    private let viewModel: RMSearchViewViewModel
    
    // MARK: - init
    init(config: Config) {
        self.viewModel =  RMSearchViewViewModel(config: config)
        self.searchView = RMSearchView(frame: .zero, viewModel: self.viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapExecureSearch)
        )
    }
    
    @objc
    private func didTapExecureSearch() {
        // TODO: - search viewmodel execute search
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
