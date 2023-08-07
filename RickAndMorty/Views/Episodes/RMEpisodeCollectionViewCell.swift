//
//  RMEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by  on 19/05/23.
//

import UIKit

final class RMEpisodeCollectionViewCell: UICollectionViewCell {
    
    public static let cellIdentifier = "RMEpisodeCollectionViewCellIdentifier"
        
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.addSubviews(episodeLabel, nameLabel, airDateLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        episodeLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }
    
    public func configure(with cellModel: RMEpisodeCollectionViewCellModel) {
        
        episodeLabel.text = cellModel.episodeCodeText
        nameLabel.text = cellModel.episodeName
        airDateLabel.text = cellModel.episodeAirDate
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            episodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            episodeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            episodeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            nameLabel.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: episodeLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: episodeLabel.trailingAnchor),
            
            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            airDateLabel.leadingAnchor.constraint(equalTo: episodeLabel.leadingAnchor),
            airDateLabel.trailingAnchor.constraint(equalTo: episodeLabel.trailingAnchor),
            airDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    public static func intrinsicHeight(with viewModel: RMEpisodeCollectionViewCellModel, width: CGFloat) -> CGFloat {
        
        let dummyCell = RMEpisodeCollectionViewCell(frame: .zero)
        
        var totalHeight: CGFloat = 0.0
        
        let verticalConstraints: [NSLayoutConstraint] = dummyCell.contentView.constraints.filter({ ($0.firstAttribute == .top) || ($0.firstAttribute == .bottom) })
        totalHeight += verticalConstraints.reduce(0.0, { $0+abs($1.constant) })
        
        let cellWidth = width
        let referenceSize = CGSize(width: cellWidth-20.0, height: CGFloat.greatestFiniteMagnitude)
        let episode = viewModel.episodeCodeText
        let name = viewModel.episodeName
        let airDate = viewModel.episodeAirDate
        let episodeCalculatedSize = episode.sizeWithFont(dummyCell.episodeLabel.font, lineBreakMode: .byWordWrapping, constrainedToSize: referenceSize)
        let nameCalculatedSize = name.sizeWithFont(dummyCell.nameLabel.font, lineBreakMode: .byWordWrapping, constrainedToSize: referenceSize)
        let airDateCalculatedSize = airDate.sizeWithFont(dummyCell.airDateLabel.font, lineBreakMode: .byWordWrapping, constrainedToSize: referenceSize)
        totalHeight += episodeCalculatedSize.height + nameCalculatedSize.height + airDateCalculatedSize.height
        
        return totalHeight
    }
}
