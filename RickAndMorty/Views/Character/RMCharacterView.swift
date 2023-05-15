//
//  RMCharacterView.swift
//  RickAndMorty
//
//  Created by  on 02/05/23.
//

import UIKit

protocol RMCharacterViewDelegate: AnyObject {
    
    func characterView(_ characterView: RMCharacterView, didSelectEpisode episode: RMEpisode)
}

final class RMCharacterView: UIView {
    
    public weak var delegate: RMCharacterViewDelegate?
    
    private let characterViewModel: RMCharacterViewModel
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterImageCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterImageCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterInformationCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterInformationCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        
        return collectionView
    }()
    
    init(characterViewModel: RMCharacterViewModel) {
        self.characterViewModel = characterViewModel
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        
        addSubviews(activityIndicator, collectionView)
        setupConstraints()
        setupCollectionView()
        
        characterViewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
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
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            
            let sectionType = self.characterViewModel.sectionTypes[section]
            return RMCharacterViewModel.collectionLayoutSection(for: sectionType)
        })
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = characterViewModel
        collectionView.dataSource = characterViewModel
    }
}

// MARK: - RMCharacterViewModelDelegate
extension RMCharacterView: RMCharacterViewModelDelegate {
    
    func didSelectEpisode(_ episode: RMEpisode) {
        
        delegate?.characterView(self, didSelectEpisode: episode)
    }
}
