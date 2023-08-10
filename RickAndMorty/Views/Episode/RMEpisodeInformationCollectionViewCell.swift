//
//  RMEpisodeInformationCollectionViewCell.swift
//  RickAndMorty
//
//  Created by  on 10/08/23.
//

import UIKit

class RMEpisodeInformationCollectionViewCell: UICollectionViewCell {
    
    public static let cellIdentifier = "RMEpisodeInformationCollectionViewCellIdentifier"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .secondarySystemBackground
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "globe")
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.masksToBounds = true
        contentView.addSubviews(titleLabel, valueLabel, iconImageView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        titleLabel.textColor = .label
        valueLabel.text = nil
        valueLabel.font = .systemFont(ofSize: 16, weight: .medium)
        iconImageView.image = nil
        iconImageView.tintColor = .label
    }
    
    public func configure(with cellModel: RMEpisodeInformationCollectionViewCellModel) {
        
        titleLabel.text = cellModel.infoTitle
        titleLabel.textColor = cellModel.infoTintColor
        if let _ = cellModel.infoValue {
            valueLabel.text = cellModel.infoValue!.capitalizedSentence
        } else {
            valueLabel.text = "None"
            valueLabel.font = .italicSystemFont(ofSize: 14)
        }
        iconImageView.image = cellModel.infoIcon
        iconImageView.tintColor = cellModel.infoTintColor
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 25),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            iconImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: titleLabel.topAnchor, constant: -10),
                
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            valueLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            valueLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/3),
        ])
    }
}
