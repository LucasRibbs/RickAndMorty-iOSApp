//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by  on 02/05/23.
//

import UIKit

final class RMCharacterViewController: UIViewController {
    
    private let characterViewModel: RMCharacterViewModel
    
    init(characterViewModel: RMCharacterViewModel) {
        self.characterViewModel = characterViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = characterViewModel.title
    }
}
