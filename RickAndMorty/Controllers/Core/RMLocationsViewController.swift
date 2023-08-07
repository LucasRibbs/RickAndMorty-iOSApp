//
//  RMLocationsViewController.swift
//  RickAndMorty
//
//  Created by  on 30/01/23.
//

import UIKit

final class RMLocationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Locations"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
        
    }
}
