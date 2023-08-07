//
//  RMEpisodesView.swift
//  RickAndMorty
//
//  Created by  on 19/05/23.
//

import UIKit

protocol RMEpisodesViewDelegate: AnyObject {
    
    func episodesView(_ episodesView: RMEpisodesView, didSelectEpisode episode: RMEpisode)
}

final class RMEpisodesView: UIView {

    public weak var delegate: RMEpisodesViewDelegate?
    
    private let episodesViewModel = RMEpisodesViewModel()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0.0
        collectionView.register(RMEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier)
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
        
        episodesViewModel.delegate = self
        episodesViewModel.fetchEpisodes()
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
        
        collectionView.dataSource = episodesViewModel
        collectionView.delegate = episodesViewModel
    }
}

// MARK: - RMCharactersViewModelDelegate
extension RMEpisodesView: RMEpisodesViewModelDelegate {
    
    func didLoadInitialEpisodes() {
        
        collectionView.reloadData()
        
        self.activityIndicator.stopAnimating()
        self.collectionView.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.collectionView.alpha = 1.0
        })
    }
    
    func didLoadAdditionalEpisodes(at indexPaths: [IndexPath]) {
                
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: indexPaths)
//            layout.invalidateLayout()
        })
    }
    
    func didSelectEpisode(_ episode: RMEpisode) {
        
        delegate?.episodesView(self, didSelectEpisode: episode)
    }
}
