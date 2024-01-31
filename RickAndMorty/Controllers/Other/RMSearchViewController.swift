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
            case location
            case episode
            
            var endpoint: RMEndpoint {
                switch self {
                case .character:
                    return .character
                case .location:
                    return .location
                case .episode:
                    return .episode
                }
            }
            
            var title: String {
                switch self {
                case .character:
                    return "Search character"
                case.location:
                    return "Search location"
                case .episode:
                    return "Search episode"
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
        
        searchView.delegate = self
        
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapExecureSearch)
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.setupKeyboard()
    }
    
    @objc
    private func didTapExecureSearch() {
        // TODO: - search viewmodel execute search
        viewModel.executeSearch()
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


extension RMSearchViewController: RMSearchViewDelegate {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        let vc = RMSearchOptionPickerViewController(option: option) {[weak self] selection in
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
        }
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        present(vc, animated: true)
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
