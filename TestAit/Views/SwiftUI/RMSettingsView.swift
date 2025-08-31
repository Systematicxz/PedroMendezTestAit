//
//  RMSettingsView.swift
//  TestAit
//
//  Created by PEDRO MENDEZ on 31/08/25.
//

import SwiftUI

struct RMSettingsView: View {
    
    let viewModel: RMSettingsViewViewModel
    
    init(viewModel: RMSettingsViewViewModel) {
        self.viewModel = viewModel
    }
   
    
    var body: some View {
            List(viewModel.cellViewModels) { viewModel in
                HStack {
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .padding(.trailing ,3)
                            .background(Color(viewModel.iconContainerColor))
                            .cornerRadius(10)
                    }
                    Text(viewModel.title)
                        .padding(.leading, 7)
                    Spacer()
                }
                .padding()
                .onTapGesture {
                    viewModel.onTapHandler(viewModel.type)
                }
        }
    }
}

struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        
        RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0) {option in
            }
        })))
    }
}
