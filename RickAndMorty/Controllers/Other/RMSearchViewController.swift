//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 05/01/24.
//

import UIKit

/// Configurable controller to search
final class RMSearchViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
    }
    
    init(config: Config) {
        let viewModel = RMSearchViewViewModel()
        self.viewModel = viewModel
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
