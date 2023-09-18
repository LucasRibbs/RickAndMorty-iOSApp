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
        label.lineBreakMode = .byTruncatingTail
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
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.masksToBounds = true
        contentView.addSubviews(titleLabel, valueLabel)
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
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
                
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            valueLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
    }
}
