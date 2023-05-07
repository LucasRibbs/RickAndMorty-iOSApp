//
//  RMCharacterImageCollectionViewCell.swift
//  RickAndMorty
//
//  Created by  on 06/05/23.
//

import UIKit

final class RMCharacterImageCollectionViewCell: UICollectionViewCell {
    
    public static let cellIdentifier = "RMCharacterImageCollectionViewCellIdentifier"
        
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let blurredImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.addBlur()
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemBackground
        contentView.addSubviews(blurredImageView, imageView)
        setupConstraints()
        contentView.bringSubviewToFront(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        blurredImageView.image = nil
    }
    
    public func configure(with cellModel: RMCharacterImageCollectionViewCellModel) {
        
        cellModel.fetchCharacterImage { [weak self] result in
            
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
//                let blurredImage = image?.blurredImage()
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    self?.blurredImageView.image = image
                }
                break
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            blurredImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurredImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            blurredImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            blurredImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
