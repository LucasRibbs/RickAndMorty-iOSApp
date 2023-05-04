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
        
        setupView()
    }
    
    private func setupView() {
        
        charactersView.delegate = self
        view.addSubview(charactersView)
        
        NSLayoutConstraint.activate([
            charactersView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            charactersView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            charactersView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            charactersView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

// MARK: - RMCharactersViewDelegate
extension RMCharactersViewController: RMCharactersViewDelegate {
    
    func charactersView(_ charactersView: RMCharactersView, didSelectCharacter character: RMCharacter) {
        //Open detail controller for given character
        let characterViewModel = RMCharacterViewModel(character: character)
        let characterVC = RMCharacterViewController(characterViewModel: characterViewModel)
        characterVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(characterVC, animated: true)
    }
}
