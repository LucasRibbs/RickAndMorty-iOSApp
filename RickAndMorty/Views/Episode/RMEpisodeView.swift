//
//  RMEpisodeView.swift
//  RickAndMorty
//
//  Created by  on 10/05/23.
//

import UIKit

final class RMEpisodeView: UIView {

    private let episodeViewModel: RMEpisodeViewModel
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        activityIndicator.tintColor = .white
        
        return activityIndicator
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMEpisodeInformationCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeInformationCollectionViewCell.cellIdentifier)
        collectionView.register(RMEpisodeCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeCharacterCollectionViewCell.cellIdentifier)
        
        return collectionView
    }()

    init(episodeViewModel: RMEpisodeViewModel) {
        self.episodeViewModel = episodeViewModel
        super.init(frame: .zero)
                
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGreen
        
        addSubviews(activityIndicator, collectionView)
        setupConstraints()
        setupCollectionView()
        
        activityIndicator.startAnimating()
        episodeViewModel.delegate = self
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
            
            let sectionType = self.episodeViewModel.sectionTypes[section]
            return RMEpisodeViewModel.collectionLayoutSection(for: sectionType)
        })
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = episodeViewModel
        collectionView.dataSource = episodeViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
}

extension RMEpisodeView: RMEpisodeViewModelDelegate {
    
    func didFetchRelatedCharacters() {
        
        collectionView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func didSelectCharacter(_ character: RMCharacter) {
        
    }
}
