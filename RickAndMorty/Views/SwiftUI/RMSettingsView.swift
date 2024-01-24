//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 22/01/24.
//

import SwiftUI

struct RMSettingsView: View {
    let viewModel: RMSettingsViewViewModel
    
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            
            HStack(spacing: 10) {
                if let image = viewModel.image {
                    Rectangle()
                        .frame(width: 40, height: 40)
                        .cornerRadius(8)
                        .foregroundColor(Color(uiColor: viewModel.iconContainerColor))
                        .overlay {
                            Image(uiImage: image)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .frame(width:  30, height: 30)
                        }
                }
                
                Text(viewModel.title)
                    .padding(.leading, 10)
                
                Spacer()
            }
            .padding(.bottom, 4)
//            .background(.red)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

#Preview {
    RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({
        return RMSettingsCellViewModel(type: $0) { option in
            
        }
    })))
}
