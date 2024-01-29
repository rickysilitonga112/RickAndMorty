//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 14/11/23.
//

import UIKit

/// Controller to show and search location
final class RMLocationViewController: UIViewController, RMLocationViewDelegate, RMLocationViewModelDelegate {
    
    
    private var primaryView = RMLocationView()
    
    private let viewModel = RMLocationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(primaryView)
        view.backgroundColor = .systemBackground
        title = "Locations"
        setupConstraints()
        addSearchButton()
        
        primaryView.delegate = self
        
        
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    
    // MARK: - private
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: RMSearchViewController.Config(type: .location))
        vc.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - RMLocationViewDelegate
    func rmLocationView(_ view: RMLocationView, didSelect location: RMLocation) {
        let detailVc = RMLocationDetailViewController(location: location)
        detailVc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVc, animated: true)
    }
    
    // MARK: - RMLocationViewModelDelegate
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }

}
