//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by  on 30/01/23.
//

import SwiftUI
import UIKit
import SafariServices
import StoreKit

final class RMSettingsViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        view.backgroundColor = .systemBackground
        
        setupHostingController()
    }

    private func setupHostingController() {
        
        let settingsView = RMSettingsView(settingsViewModel: RMSettingsViewModel.allSettingOptions, delegate: self)
        
        let settingsViewHostingController = UIHostingController(rootView: settingsView)
        
        addChild(settingsViewHostingController)
        settingsViewHostingController.didMove(toParent: self)
        
        view.addSubview(settingsViewHostingController.view)
        settingsViewHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsViewHostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsViewHostingController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsViewHostingController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsViewHostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension RMSettingsViewController: RMSettingsViewDelegate {
    
    func settingsView(_ settingsView: RMSettingsView, didTapOption option: RMSettingsOption) {

        if let url = option.targetUrl {
            //Open website
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
        else if option == .rateApp {
            //Show rating prompt
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
}
