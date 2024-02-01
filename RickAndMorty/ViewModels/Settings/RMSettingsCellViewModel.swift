//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 22/01/24.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
    let id = UUID()
    public let type: RMSettingsOption
    public var onTapHandler: (RMSettingsOption) -> Void
    
    // MARK: - public
    public var image: UIImage? {
        return type.image
    }
    public var title: String {
        return type.displayTitle
    }
    
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
    
    
    // MARK: - init
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
}
