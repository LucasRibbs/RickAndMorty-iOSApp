//
//  RMCharactersView.swift
//  RickAndMorty
//
//  Created by  on 31/01/23.
//

import UIKit

protocol RMCharactersViewDelegate: AnyObject {
    
    func charactersView(_ charactersView: RMCharactersView, didSelectCharacter character: RMCharacter)
}

final class RMCharactersView: UIView {
    
    public weak var delegate: RMCharactersViewDelegate?
    
    public static let defaultSpacing: CGFloat = 5.0
    public static let numberOfColumns: Int = 3
    public static let footerHeight: CGFloat = 100.0
    
    public static var columnWidth: CGFloat {
        let columns = CGFloat(numberOfColumns)
        let spacing = defaultSpacing
        let bounds = UIScreen.main.bounds
        let columnWidth = (bounds.width-spacing*(columns+1))/columns
        return columnWidth
    }
    
    private let charactersViewModel = RMCharactersViewModel()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    private let collectionView: UICollectionView = {
        let layout = RMCharactersViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0.0
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(collectionView, activityIndicator)
        setupConstraints()
        activityIndicator.startAnimating()
        setupCollectionView()
        
        charactersViewModel.delegate = self
        charactersViewModel.fetchCharacters()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("Not supported")
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    private func setupCollectionView() {
        
        collectionView.dataSource = charactersViewModel
        collectionView.delegate = charactersViewModel
        (collectionView.collectionViewLayout as! RMCharactersViewLayout).delegate = charactersViewModel
    }
}

// MARK: - RMCharacterViewModelDelegate
extension RMCharactersView: RMCharacterViewModelDelegate {
    
    func didLoadInitialCharacters() {
        collectionView.reloadData()
        
        self.activityIndicator.stopAnimating()
        self.collectionView.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.collectionView.alpha = 1.0
        })
    }
    
    func didSelectCharacter(_ character: RMCharacter) {
        
        delegate?.charactersView(self, didSelectCharacter: character)
    }
}
