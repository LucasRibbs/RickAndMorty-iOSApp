//
//  RMEpisodeViewModel.swift
//  RickAndMorty
//
//  Created by  on 10/05/23.
//

import UIKit

protocol RMEpisodeViewModelDelegate: AnyObject {
    
    func didFetchRelatedCharacters()
    func didSelectCharacter(_ character: RMCharacter)
}

final class RMEpisodeViewModel: NSObject {
    
    public weak var delegate: RMEpisodeViewModelDelegate? {
        didSet {
            fetchRelatedCharacters()
        }
    }
    
    private let episode: RMEpisode
    
    private var characters: [RMCharacter]? {
        didSet {
            setupSections()
            delegate?.didFetchRelatedCharacters()
        }
    }
    
    init(episode: RMEpisode) {
        self.episode = episode
        super.init()
    }
    
    public var title: String {
        return episode.name.uppercased()
    }
    
    enum SectionType {
        case information(cellModels: [RMEpisodeInformationCollectionViewCellModel])
        case characters(cellModels: [RMCharacterCollectionViewCellModel])
    }
    
    public var sectionTypes: [SectionType] = []
    
    public static func collectionLayoutSection(for sectionType: SectionType) -> NSCollectionLayoutSection {
        
        switch sectionType {
        case .information:
            return collectionLayoutSectionForInformationSection()
        case .characters:
            return collectionLayoutSectionForCharactersSection()
        }
    }
    
    private func setupSections() {
        
        guard let characters = characters else { return }
        
        sectionTypes = [
            .information(cellModels: [
                RMEpisodeInformationCollectionViewCellModel(infoType: .name, value: episode.name),
                RMEpisodeInformationCollectionViewCellModel(infoType: .episode, value: episode.episode),
                RMEpisodeInformationCollectionViewCellModel(infoType: .airDate, value: episode.air_date),
                RMEpisodeInformationCollectionViewCellModel(infoType: .created, value: episode.created),
            ]),
            .characters(cellModels: characters.map({ character in
                RMCharacterCollectionViewCellModel(characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
            }))
        ]
    }
    
    private static func collectionLayoutSectionForInformationSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .absolute(125)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(125)
            ),
            subitems: [item, item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 7.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        return section
    }
    
    private static func collectionLayoutSectionForCharactersSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 0.0, bottom: 2.5, trailing: 0.0)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.75),
                heightDimension: .estimated(151)
            ),
            subitems: [item, item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 2.5, bottom: 0.0, trailing: 2.5)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return section
    }
    
    private func fetchRelatedCharacters() {
        
        let requests: [RMRequest] = episode.characters.compactMap({ URL(string: $0) }).compactMap({ RMRequest(url: $0) })
        
        var characters: [RMCharacter] = []
        let group = DispatchGroup()
        for request in requests {
            
            group.enter()
            
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                
                defer { group.leave() }

                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        
        group.notify(queue: .main, execute: {
            self.characters = characters
        })
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension RMEpisodeViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return sectionTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let sectionType = sectionTypes[section]
        switch sectionType {
        case .information(let cellModels):
            return cellModels.count
        case .characters(let cellModels):
            return cellModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionType = sectionTypes[indexPath.section]
        switch sectionType {
        case .information(let cellModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeInformationCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMEpisodeInformationCollectionViewCell else { fatalError() }
            
            cell.configure(with: cellModels[indexPath.item])
            return cell
            
        case .characters(let cellModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeCharacterCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMEpisodeCharacterCollectionViewCell else { fatalError() }
            
            cell.configure(with: cellModels[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let sectionType = sectionTypes[indexPath.section]
        switch sectionType {
        case .characters(let cellModels):
//            guard let character = cellModels[indexPath.item].character as? RMCharacter else { return }
//            delegate?.didSelectCharacter(character)
            return
        default:
            return
        }
    }
}
