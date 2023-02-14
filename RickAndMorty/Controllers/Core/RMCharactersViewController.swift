//
//  RMCharactersViewController.swift
//  RickAndMorty
//
//  Created by  on 30/01/23.
//

import UIKit

final class RMCharactersViewController: UIViewController {

    private let charactersView = RMCharactersView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        setUpView()
    }
    
    private func setUpView() {
        
        view.addSubview(charactersView)
        NSLayoutConstraint.activate([
            charactersView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            charactersView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            charactersView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            charactersView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}
