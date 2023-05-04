//
//  ViewController.swift
//  RickAndMorty
//
//  Created by  on 30/01/23.
//

import UIKit

final class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }

    private func setupViewControllers() {
        
        let charactersVC = RMCharactersViewController()
        let locationsVC = RMLocationsViewController()
        let episodesVC = RMEpisodesViewController()
        let settingsVC = RMSettingsViewController()

        let navigationVC1 = UINavigationController(rootViewController: charactersVC)
        let navigationVC2 = UINavigationController(rootViewController: locationsVC)
        let navigationVC3 = UINavigationController(rootViewController: episodesVC)
        let navigationVC4 = UINavigationController(rootViewController: settingsVC)
        
        navigationVC1.navigationBar.prefersLargeTitles = true
        navigationVC2.navigationBar.prefersLargeTitles = true
        navigationVC3.navigationBar.prefersLargeTitles = true
        navigationVC4.navigationBar.prefersLargeTitles = true

        navigationVC1.tabBarItem = UITabBarItem(title:"Characters", image:UIImage(systemName: "person"), tag:1)
        navigationVC2.tabBarItem = UITabBarItem(title:"Locations", image:UIImage(systemName: "globe"), tag:2)
        navigationVC3.tabBarItem = UITabBarItem(title:"Episodes", image:UIImage(systemName: "tv"), tag:3)
        navigationVC4.tabBarItem = UITabBarItem(title:"Settings", image:UIImage(systemName: "gear"), tag:4)

        setViewControllers([navigationVC1,navigationVC2,navigationVC3,navigationVC4], animated: true)
    }
}

