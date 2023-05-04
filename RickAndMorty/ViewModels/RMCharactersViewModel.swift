//
//  RMCharactersViewModel.swift
//  RickAndMorty
//
//  Created by  on 31/01/23.
//

import UIKit

protocol RMCharacterViewModelDelegate: AnyObject {
    
    func didLoadInitialCharacters()
    func didSelectCharacter(_ character: RMCharacter)
}

final class RMCharactersViewModel: NSObject {
    
    public weak var delegate: RMCharacterViewModelDelegate?
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellModel(characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
                cellModels.append(viewModel)
            }
        }
    }
    
    private var cellModels: [RMCharacterCollectionViewCellModel] = []
    
    private var apiInfo: RMAllCharactersResponse.Info? = nil
    
    public func fetchCharacters() {
        
        RMService.shared.execute(.allCharactersRequest, expecting: RMAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let allCharactersResponse):
                let results = allCharactersResponse.results
                let info = allCharactersResponse.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
                break
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
    
    public func fetchAdditionalCharacters() {
        
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return (apiInfo?.next != nil)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension RMCharactersViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Not supported cell")
        }
        let cellModel = cellModels[indexPath.row]
        cell.configure(with: cellModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError("Unsupported!")
        }
        
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

// MARK: - RMCharactersViewFlowLayoutDelegate
extension RMCharactersViewModel: RMCharactersViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        
//        guard let cell = collectionView.cellForItem(at: indexPath) as? RMCharacterCollectionViewCell else { return 0.0 }
        return RMCharacterCollectionViewCell.intrinsicHeight(with: cellModels[indexPath.item])
    }
}

// MARK: - UIScrollViewDelegate
extension RMCharactersViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator else { return }
        
        let contentOffset = scrollView.contentOffset.y
        let contentViewHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        
        if(contentOffset >= contentViewHeight-scrollViewHeight) {
            print("Should start fetching more characters")
        }
    }
}
