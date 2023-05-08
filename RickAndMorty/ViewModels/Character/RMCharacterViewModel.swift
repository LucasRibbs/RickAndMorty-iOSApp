//
//  RMCharacterViewModel.swift
//  RickAndMorty
//
//  Created by  on 02/05/23.
//

import UIKit

final class RMCharacterViewModel: NSObject {
    
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
        super.init()
        
        setupSections()
    }
    
    public var title: String {
        return character.name.uppercased()
    }
    
    enum SectionType {
        case image(cellModel: RMCharacterImageCollectionViewCellModel)
        case information(cellModels: [RMCharacterInformationCollectionViewCellModel])
        case episode(cellModels: [RMCharacterEpisodeCollectionViewCellModel])
    }
    
    public var sectionTypes: [SectionType] = []
    
    public static func collectionLayoutSection(for sectionType: SectionType) -> NSCollectionLayoutSection {
        
        switch sectionType {
        case .image:
            return collectionLayoutSectionForImageSection()
        case .information:
            return collectionLayoutSectionForInformationSection()
        case .episode:
            return collectionLayoutSectionForEpisodeSection()
        }
    }
    
    private func setupSections() {
        
        sectionTypes = [
            .image(cellModel: RMCharacterImageCollectionViewCellModel(imageUrl: character.image)),
            .information(cellModels: [
                RMCharacterInformationCollectionViewCellModel(infoType: .status, value: character.status.string),
                RMCharacterInformationCollectionViewCellModel(infoType: .gender, value: character.gender.string),
                RMCharacterInformationCollectionViewCellModel(infoType: .species, value: character.species),
                RMCharacterInformationCollectionViewCellModel(infoType: .type, value: character.type),
                RMCharacterInformationCollectionViewCellModel(infoType: .origin, value: character.origin.name),
                RMCharacterInformationCollectionViewCellModel(infoType: .location, value: character.location.name),
                RMCharacterInformationCollectionViewCellModel(infoType: .created, value: character.created),
                RMCharacterInformationCollectionViewCellModel(infoType: .totalEpisodes, value: character.episodeCount)
            ]),
            .episode(cellModels: character.episode.map({ episodeUrl in
                RMCharacterEpisodeCollectionViewCellModel(episodeUrl: episodeUrl)
            }))
        ]
    }
        
    public static func collectionLayoutSectionForImageSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(250)
            )
        )
//        item.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(250)
            ),
            subitems: [item]
        )
//        group.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        return section
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
//        group.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 7.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        return section
    }
    
    private static func collectionLayoutSectionForEpisodeSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.75),
                heightDimension: .absolute(145)
            ),
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 2.5, bottom: 0.0, trailing: 2.5)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 2.5, bottom: 10.0, trailing: 2.5)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
}

extension RMCharacterViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return sectionTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let sectionType = sectionTypes[section]
        switch sectionType {
        case .image:
            return 1
        case .information(let cellModels):
            return cellModels.count
        case .episode(let cellModels):
            return cellModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionType = sectionTypes[indexPath.section]
        switch sectionType {
        case .image(let cellModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterImageCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterImageCollectionViewCell else { fatalError() }
            
            cell.configure(with: cellModel)
            return cell
            
        case .information(let cellModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterInformationCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterInformationCollectionViewCell else { fatalError() }
            
            cell.configure(with: cellModels[indexPath.item])
            return cell
            
        case .episode(let cellModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterEpisodeCollectionViewCell else { fatalError() }
            
            cell.configure(with: cellModels[indexPath.item])
            return cell
        }
    }
}
