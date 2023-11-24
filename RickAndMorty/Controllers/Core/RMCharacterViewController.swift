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
            pathComponents: ["1"],
            queryParameters: [
                URLQueryItem(name: "name", value: "rick"),
                URLQueryItem(name: "status", value: "alive")
            ]
        )
        
        print(request.url)
        
    }

}
