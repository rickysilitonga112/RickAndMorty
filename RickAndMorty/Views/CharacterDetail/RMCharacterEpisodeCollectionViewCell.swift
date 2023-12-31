//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 28/12/23.
//

import UIKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterEpisodeCollectionViewCell"
    
    private let seasonLabel: UILabel = {
        let label =  UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label =  UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let airDataLabel: UILabel = {
        let label =  UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.addSubviews(seasonLabel, nameLabel, airDataLabel)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seasonLabel.text = nil
        nameLabel.text = nil
        airDataLabel.text = nil
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            seasonLabel.topAnchor.constraint(equalTo: topAnchor),
            seasonLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            seasonLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            seasonLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            airDataLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            airDataLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            airDataLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            airDataLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
        ])
    }
    
    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) {
        viewModel.registerForData { [weak self] data in
            // Main Que
            self?.nameLabel.text = data.name
            self?.seasonLabel.text = "Episode \(data.episode)"
            self?.airDataLabel.text = "Aired on \(data.air_date)"
        }
        viewModel.fetchEpisode()
    }
}
