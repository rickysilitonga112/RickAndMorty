//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 14/11/23.
//

import UIKit

/// Controller to home and root tab controllers
final class RMTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabs()
    }
    
    private func setUpTabs() {
        let charactersVC = RMCharacterViewController()
        let episodesVC = RMEpisodeViewController()
        let locationsVC = RMLocationViewController()
        let settingsVC = RMSettingsViewController()
        
//        // set the large title display mode for all of the view controller
        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic
        locationsVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        
        // wrap the view controller to UINavigationController
        let nav1 = UINavigationController(rootViewController: charactersVC)
        let nav2 = UINavigationController(rootViewController: episodesVC)
        let nav3 = UINavigationController(rootViewController: locationsVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        
        // set the icons for all navigation item
        nav1.tabBarItem = UITabBarItem(
            title: "Characters",
            image: UIImage(systemName: "person"),
            tag: 1
        )
        nav2.tabBarItem = UITabBarItem(
            title: "Episodes",
            image: UIImage(systemName: "tv"),
            tag: 2
        )
        nav3.tabBarItem = UITabBarItem(
            title: "Locations",
            image: UIImage(systemName: "globe"),
            tag: 3
        )
        nav4.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: 4
        )
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        // setup the view controllers
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
    }
}

