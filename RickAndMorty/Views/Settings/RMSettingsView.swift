//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by  on 19/09/23.
//

import SwiftUI

protocol RMSettingsViewDelegate: AnyObject {
    
    func settingsView(_ settingsView: RMSettingsView, didTapOption option: RMSettingsOption)
}

struct RMSettingsView: View {
            
    let settingsViewModel: RMSettingsViewModel
    
    public weak var delegate: RMSettingsViewDelegate?
    
    var body: some View {
        List(settingsViewModel.cellModels) { cellModel in
            HStack(spacing: 10) {
                if let icon = cellModel.icon {
                    Image(uiImage: icon)
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(Color(cellModel.iconContainerColor))
                        .cornerRadius(5)
                }
                Text(cellModel.title)
                Spacer()
            }
            .listRowInsets(EdgeInsets())
            .padding(10)
            .onTapGesture(perform: {
                delegate?.settingsView(self, didTapOption: cellModel.option)
            })
        }
    }
}

struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsView(settingsViewModel: RMSettingsViewModel.allSettingOptions)
    }
}
