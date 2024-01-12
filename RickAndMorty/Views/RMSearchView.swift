//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 05/01/24.
//

import UIKit

class RMSearchView: UIView {

    private let viewModel: RMSearchViewViewModel
    
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
