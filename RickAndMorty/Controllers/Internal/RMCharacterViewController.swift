//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by  on 02/05/23.
//

import UIKit

final class RMCharacterViewController: UIViewController {
    
    private let characterView: RMCharacterView
    
    init(character: RMCharacter) {
        let characterViewModel = RMCharacterViewModel(character: character)
        self.characterView = RMCharacterView(characterViewModel: characterViewModel)
        
        super.init(nibName: nil, bundle: nil)
        
        title = characterViewModel.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(characterView)
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    @objc private func didTapShare() {
        
        
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            characterView.topAnchor.constraint(equalTo: view.topAnchor),
            characterView.leftAnchor.constraint(equalTo: view.leftAnchor),
            characterView.rightAnchor.constraint(equalTo: view.rightAnchor),
            characterView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
