//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 14/11/23.
//

import UIKit

/// Controller to show and search character
final class RMCharacterViewController: UIViewController {
    let characterListView = RMCharacterListView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Characters"
        
        self.setupView()
    }

    
    private func setupView() {
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        // for testing
        // create a request object
        let request = RMRequest(
            endpoint: .character,
            pathComponents: [],
            queryParameters: [
                URLQueryItem(name: "name", value: "rick"),
                URLQueryItem(name: "status", value: nil)
            ]
        )
        
        print("Debug: URL: \(String(describing: request.url))")
    }
}
