//
//  RMCharactersViewModel.swift
//  RickAndMorty
//
//  Created by  on 31/01/23.
//

import UIKit

protocol RMCharacterViewModelDelegate: AnyObject {
    
    func didLoadInitialCharacters()
    func didLoadAdditionalCharacters(at indexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
}

final class RMCharactersViewModel: NSObject {
    
    public weak var delegate: RMCharacterViewModelDelegate?
    
    private var isLoadingCharacters: Bool = true
    
    private var characters: [RMCharacter] = [] {
        didSet {
            cellModels = characters.map({ RMCharacterCollectionViewCellModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string: $0.image)) })
        }
    }
    
    private var cellModels: [RMCharacterCollectionViewCellModel] = []
    
    private var apiInfo: RMAllCharactersResponse.Info? = nil
    
    public func fetchCharacters() {
        
        isLoadingCharacters = true
        
        RMService.shared.execute(.allCharactersRequest, expecting: RMAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let allCharactersResponse):
                let results = allCharactersResponse.results
                let info = allCharactersResponse.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                    self?.isLoadingCharacters = false
                }
                break
            case .failure(let error):
                print(String(describing: error))
                self?.isLoadingCharacters = false
                break
            }
        }
    }
    
    public func fetchAdditionalCharacters() {
        
        guard !isLoadingCharacters else { return }
        guard let nextUrlString = apiInfo?.next, let nextUrl = URL(string: nextUrlString) else { return }
        
        let strong_self = self
        isLoadingCharacters = true
//        print("Fetching more characters")
        
        let request = RMRequest(url: nextUrl)!
        RMService.shared.execute(request, expecting: RMAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let charactersResponse):
                let info = charactersResponse.info
                let results = charactersResponse.results
                
                let firstIdx = strong_self.characters.count
                let lastIdx = strong_self.characters.count + results.count - 1
                let newIndexPaths: [IndexPath] = Array(firstIdx...lastIdx).map({ IndexPath(item: $0, section: 0) })
    
                strong_self.apiInfo = info
                strong_self.characters.append(contentsOf: results)
                
                DispatchQueue.main.async {
                    self?.delegate?.didLoadAdditionalCharacters(at: newIndexPaths)
                    self?.isLoadingCharacters = false
                }
                break
            case .failure(let error):
                print(String(describing: error))
                self?.isLoadingCharacters = false
                break
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool { return (apiInfo?.next != nil) }
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
        
        let character = characters[indexPath.item]
        delegate?.didSelectCharacter(character)
    }
}

// MARK: - RMCharactersViewFlowLayoutDelegate
extension RMCharactersViewModel: RMCharactersViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {

        return RMCharacterCollectionViewCell.intrinsicHeight(with: cellModels[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForFooterInSection section: Int) -> CGFloat {
        
        return shouldShowLoadMoreIndicator ? 100.0 : 0.0
    }
}

// MARK: - UIScrollViewDelegate
extension RMCharactersViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isLoadingCharacters else { return }
        
//        let contentOffsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let scrollViewHeight = scrollView.frame.height
//
//        if(contentOffsetY >= contentHeight-scrollViewHeight-100.0) {
//            print("Should start fetching more characters")
//
//            fetchAdditionalCharacters()
//        }
//
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let contentOffsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let scrollViewHeight = scrollView.frame.height
            
            if(contentOffsetY >= contentHeight-scrollViewHeight-100.0) {
                
                self?.fetchAdditionalCharacters()
            }
            
            t.invalidate()
        }
    }
}
