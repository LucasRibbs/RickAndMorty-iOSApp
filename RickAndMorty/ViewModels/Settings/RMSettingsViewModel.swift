//
//  RMSettingsViewModel.swift
//  RickAndMorty
//
//  Created by  on 18/09/23.
//

import Foundation

struct RMSettingsViewModel {
    
    let cellModels: [RMSettingsCellModel]
    
    static var allSettingOptions: RMSettingsViewModel {
        return RMSettingsViewModel(cellModels: RMSettingsOption.allCases.map({ RMSettingsCellModel(option: $0) }))
    }
}
