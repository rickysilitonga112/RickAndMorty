//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 31/12/23.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if let url = url {
            print("URL: \(url)")
        }
    }
}
