//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 14/11/23.
//

import UIKit

/// Controller to show and search character
final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Characters"
        
        
        let request = RMRequest(
            endpoint: .character, 
            pathComponents: [],
            queryParameters: [
                URLQueryItem(name: "name", value: "rick"),
                URLQueryItem(name: "status", value: "alive")
            ]
        )
        
        print(request.url)
        
        RMService.shared.execute(.listCharactersRequests, expecting: RMGetAllCharacterResponse.self) { result in
            switch result {
            case .success(let model):
                print("DEBUG - Total info count: \(model.info.count)")
                print("DEBUG - Total info pages: \(model.info.pages)")
                print("DEBUG - Page results count: \(model.results.count)")
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
    }

}
