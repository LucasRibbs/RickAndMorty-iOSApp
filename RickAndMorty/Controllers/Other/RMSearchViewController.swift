//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by  on 03/08/23.
//

import UIKit

class RMSearchViewController: UIViewController {
    
    enum Configuration {
        case character
        case location
        case episode
    }
    
    private let configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        view.backgroundColor = .red
    }
}
