//
//  RMEpisodeView.swift
//  RickAndMorty
//
//  Created by  on 10/05/23.
//

import UIKit

final class RMEpisodeView: UIView {

    private let episodeViewModel: RMEpisodeViewModel

    init(episodeViewModel: RMEpisodeViewModel) {
        self.episodeViewModel = episodeViewModel
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGreen
        
//        addSubviews(activityIndicator, collectionView)
//        setupConstraints()
//        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
}
