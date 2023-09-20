//
//  RMSettingsCellModel.swift
//  RickAndMorty
//
//  Created by  on 18/09/23.
//

import UIKit

struct RMSettingsCellModel: Identifiable, Hashable {
    
    public let id = UUID()
    
    public let option: RMSettingsOption
    
    public var title: String { return option.title }
    public var icon: UIImage? { return option.icon }
    public var iconContainerColor: UIColor { return option.iconContainerColor }
}
