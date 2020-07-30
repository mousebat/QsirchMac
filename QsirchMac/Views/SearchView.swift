//
//  SearchView.swift
//  QsirchMac
//
//  Created by Elliot Cater on 03/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import SwiftUI

// MARK: - Main Search View
struct SearchView: View {
    @EnvironmentObject var networkManager:NetworkManager
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBarView().background(Color(.windowBackgroundColor)).cornerRadius(0)//corner radius override - stops the weird double corner at the bottom of search bar!
            if networkManager.filesToDisplay {
                ResultsView().background(VisualEffectView(material: NSVisualEffectView.Material.popover, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))
            }
            if (networkManager.ErrorReturned != nil) {
                HStack {
                    Text("\(networkManager.ErrorReturned!)").font(.headline)
                }.padding().background(VisualEffectView(material: NSVisualEffectView.Material.popover, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))
            }
            if (networkManager.progressIndicator == true) {
                ProgressIndicatorView()
            }
            
        }
    }
}

// MARK: - Preview Loader
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView().environmentObject(NetworkManager())
    }
}
