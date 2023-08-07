//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by  on 10/05/23.
//

import UIKit

final class RMEpisodeViewController: UIViewController {
    
    private let episodeView: RMEpisodeView
    
    init(episode: RMEpisode) {
        let episodeViewModel = RMEpisodeViewModel(episode: episode)
        self.episodeView = RMEpisodeView(episodeViewModel: episodeViewModel)
        
        super.init(nibName: nil, bundle: nil)
        
        title = episodeViewModel.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(episodeView)
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    @objc private func didTapShare() {
        
        
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            episodeView.topAnchor.constraint(equalTo: view.topAnchor),
            episodeView.leftAnchor.constraint(equalTo: view.leftAnchor),
            episodeView.rightAnchor.constraint(equalTo: view.rightAnchor),
            episodeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
