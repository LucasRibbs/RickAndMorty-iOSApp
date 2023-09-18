//
//  RMEpisodeCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by  on 10/08/23.
//

import UIKit

class RMEpisodeCharacterCollectionViewCell: UICollectionViewCell {
    
    public static let cellIdentifier = "RMEpisodeCharacterCollectionViewCellIdentifier"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        setupLayer()
        contentView.addSubviews(imageView, nameLabel, statusLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("Not supported")
    }
    
    private func setupLayer() {
        
        contentView.layer.cornerRadius = 5
        contentView.layer.shadowColor = UIColor.secondaryLabel.cgColor
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowRadius = 1.0
        contentView.layer.shadowOffset = CGSize(width: 0, height: -3)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            statusLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setupLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
    
    public func configure(with cellModel: RMCharacterCollectionViewCellModel) {
        
        nameLabel.text = cellModel.characterName
        statusLabel.text = cellModel.characterStatusText
        
        cellModel.fetchCharacterImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
                break
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
