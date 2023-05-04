//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by  on 02/05/23.
//

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {

    static let identifier = "RMFooterLoadingCollectionReusableViewIdentifier"
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(activityIndicator)
        setupConstraints()
        startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func startAnimating() {
        
        activityIndicator.startAnimating()
    }
    
    public func stopAnimating() {
        
        activityIndicator.stopAnimating()
    }
}
