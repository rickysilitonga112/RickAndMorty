//
//  RMSettingsOption.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 22/01/24.
//

import UIKit

enum RMSettingsOption: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "Api Reference"
        case .viewSeries:
            return "View Video Series"
        case .viewCode:
            return "View App Code"
        }
    }
    var image: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemTeal
        case .contactUs:
            return .systemPink
        case .terms:
            return .systemBlue
        case .privacy:
            return .systemMint
        case .apiReference:
            return .systemRed
        case .viewSeries:
            return .systemOrange
        case .viewCode:
            return .systemYellow
        }
    }
    
    var optionUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://rickandmortyapi.com/support-us")
        case .terms:
            return URL(string: "https://iosacademy.io/terms/")
        case .privacy:
            return URL(string: "https://iosacademy.io/privacy/")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/documentation")
        case .viewSeries:
            return URL(string: "https://www.youtube.com/playlist?list=PLZ5bOCJTjrnwR3iX0I6yXhUQax5CoXN_t")
        case .viewCode:
            return URL(string: "https://github.com/rickysilitonga112/RickAndMorty")
        }
    }
}
