//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by  on 01/02/23.
//

import UIKit

final class RMCharacterCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RMCharacterCollectionViewCellIdentifier"
    
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
        contentView.layer.shadowOffset = CGSize(width: -3, height: 3)
    }
    
    private func setupConstraints() {
        
        let cellWidth = RMCharactersViewLayout.columnWidth
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: cellWidth),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
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
    
    public func configure(with viewModel: RMCharacterCollectionViewCellModel) {
        
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        
        viewModel.fetchCharacterImage { [weak self] result in
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
    
    private static let dummyCell = RMCharacterCollectionViewCell(frame: .zero)
    
    public static func intrinsicHeight(with viewModel: RMCharacterCollectionViewCellModel) -> CGFloat {
        
        var totalHeight: CGFloat = 0.0
        
        let verticalConstraints: [NSLayoutConstraint] = dummyCell.contentView.constraints.filter({ ($0.firstAttribute == .top) || ($0.firstAttribute == .bottom) })
        totalHeight += verticalConstraints.reduce(0.0, { $0+abs($1.constant) })
        
        let cellWidth = RMCharactersViewLayout.columnWidth
        let imgConstraint: NSLayoutConstraint? = dummyCell.imageView.constraints.first(where: {
            ($0.firstAttribute == .height && $0.secondAttribute == .width) || ($0.firstAttribute == .width && $0.secondAttribute == .height)
        })
        totalHeight += cellWidth*(imgConstraint?.multiplier ?? 1.0)
        
        let referenceSize = CGSize(width: cellWidth-10.0, height: CGFloat.greatestFiniteMagnitude)
        let name = viewModel.characterName
        let status = viewModel.characterStatusText
        let nameCalculatedSize = name.sizeWithFont(dummyCell.nameLabel.font, lineBreakMode: .byWordWrapping, constrainedToSize: referenceSize)
        let statusCalculatedSize = status.sizeWithFont(dummyCell.statusLabel.font, lineBreakMode: .byWordWrapping, constrainedToSize: referenceSize)
        totalHeight += nameCalculatedSize.height + statusCalculatedSize.height
        
        return totalHeight
    }
}
