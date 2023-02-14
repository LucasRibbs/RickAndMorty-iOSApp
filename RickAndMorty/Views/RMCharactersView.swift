//
//  RMCharactersView.swift
//  RickAndMorty
//
//  Created by  on 31/01/23.
//

import UIKit

final class RMCharactersView: UIView {
    
    private let charactersViewModel = RMCharactersViewModel()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    private let collectionView: UICollectionView = {
//        let defaultSpacing: CGFloat = 10.0
//        let numberOfColumns: Int = 3
        let layout = RMCharactersCollectionViewFlowLayout(columns: numberOfColumns)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: defaultSpacing, bottom: defaultSpacing, right: defaultSpacing)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0.0
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(collectionView, activityIndicator)
        setUpConstraints()
        activityIndicator.startAnimating()
        setUpCollectionView()
        
        charactersViewModel.fetchCharacters()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("Not supported")
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    private func setUpCollectionView() {
        
        collectionView.dataSource = charactersViewModel
        collectionView.delegate = charactersViewModel
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.activityIndicator.stopAnimating()
            self.collectionView.isHidden = false
            UIView.animate(withDuration: 0.4, animations: {
                self.collectionView.alpha = 1.0
            })
        })
    }
}

extension RMCharactersView {
    
    static let defaultSpacing: CGFloat = 10.0
    static let numberOfColumns: Int = 3
}

final class RMCharactersCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private let columns: Int

    init(columns: Int) {
        self.columns = columns
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
                
        for i in stride(from: columns-1, to: attributes.count, by: columns) {
            
            let attributesSlice = attributes[(i+1-columns)...i]
            let maxHeight = attributesSlice.map { attribute in
                return attribute.frame.height
            }.max()
            
            attributesSlice.forEach { attribute in
                attribute.size = CGSize(width: attribute.frame.width,
                                        height: maxHeight ?? attribute.frame.height)
            }
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        
        return true
    }
}
