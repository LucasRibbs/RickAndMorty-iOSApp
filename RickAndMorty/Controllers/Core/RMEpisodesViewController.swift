//
//  RMEpisodesViewController.swift
//  RickAndMorty
//
//  Created by  on 30/01/23.
//

import UIKit

final class RMEpisodesViewController: UIViewController {
    
    private let episodesView = RMEpisodesView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episodes"
        view.backgroundColor = .systemBackground
        
        setupView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
        
    }
    
    private func setupView() {
        
        episodesView.delegate = self
        view.addSubview(episodesView)
        
        NSLayoutConstraint.activate([
            episodesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            episodesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

// MARK: - RMEpisodesViewDelegate
extension RMEpisodesViewController: RMEpisodesViewDelegate {    
    
    func episodesView(_ episodesView: RMEpisodesView, didSelectEpisode episode: RMEpisode) {
        //Open detail controller for given episode
        let episodeVC = RMEpisodeViewController(episode: episode)
        episodeVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(episodeVC, animated: true)
    }
}
