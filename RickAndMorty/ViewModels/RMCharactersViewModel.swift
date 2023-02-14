//
//  RMCharactersViewModel.swift
//  RickAndMorty
//
//  Created by  on 31/01/23.
//

import UIKit

final class RMCharactersViewModel: NSObject {
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellModel(characterImageUrl: URL(string: character.image), characterName: character.name, characterStatus: character.status)
                cellModels.append(viewModel)
            }
            
            
        }
    }
    
    private var cellModels: [RMCharacterCollectionViewCellModel] = []
    
    func fetchCharacters() {
        
        RMService.shared.execute(.allCharactersRequest, expecting: RMAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let allCharactersResponse):
                let results = allCharactersResponse.results
                self?.characters = results
                break
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}

extension RMCharactersViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Not supported cell")
        }
        let viewModel = cellModels[indexPath.row]
        cell.configure(with: viewModel)
        
        return cell
    }
}
