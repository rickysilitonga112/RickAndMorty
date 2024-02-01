//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 14/11/23.
//

import UIKit
import SwiftUI
import SafariServices
import StoreKit

 /// Controller to show various app options and settings
final class RMSettingsViewController: UIViewController {
    private var settingsSwiftUIController: UIHostingController<RMSettingsView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Settings"
        
        addSettingsSwiftUIController()
    }
    
    private func addSettingsSwiftUIController() {
        let settingsSwiftUIController = UIHostingController(
            rootView: RMSettingsView (
                viewModel: RMSettingsViewViewModel(
                    cellViewModels: RMSettingsOption.allCases.compactMap({ option in
                        RMSettingsCellViewModel(type: option) {[weak self] option in
                            self?.handleTap(option: option)
                        }
                    })
                )
            )
        )
        
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leftAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIController.view.rightAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        self.settingsSwiftUIController = settingsSwiftUIController
    }
    
    private func handleTap(option: RMSettingsOption) {
        guard Thread.current.isMainThread else {
            return
        }
        
        if let url = option.optionUrl {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else {
            // show rate app modal prompt
            let requestWorkItem = DispatchWorkItem {
                self.presentReview()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: requestWorkItem)
        }
    }
    
    /// Presents the rating and review request view after a two-second delay.
    private func presentReview() {
        guard let scene = UIApplication.shared.foregroundActiveScene else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
}

extension UIApplication {
    var foregroundActiveScene: UIWindowScene? {
        connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
}
