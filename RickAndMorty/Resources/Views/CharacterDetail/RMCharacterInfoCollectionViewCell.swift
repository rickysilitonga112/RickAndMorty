//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 28/12/23.
//

import UIKit

class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterInfoCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
        
        ])
    }
    
    public func configure(with: RMCharacterInfoCollectionViewCellViewModel) {
        
    }
}
