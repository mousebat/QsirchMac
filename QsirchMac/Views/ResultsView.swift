//
//  ResultsView.swift
//  QsirchMac
//
//  Created by Elliot Cater on 27/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import SwiftUI


// MARK: - Search Results
struct ResultsView: View {
    @EnvironmentObject var networkManager:NetworkManager
    @State var selection:String?
    
    @State var alertStatus:Bool = false
    @State var alertHeader:String = ""
    @State var alertMessage:String = ""
    
    var body: some View {
        NavigationView {
            List (networkManager.FileList!.items, id: \.id) { file in
                NavigationLink(destination: FileDetailView(fileDetail: file), tag: file.id, selection: self.$selection) {
                    FileRowView(fileRow: file)
                }
            }
            Rectangle().frame(maxWidth: 0, maxHeight: .infinity)
        }.frame(minHeight:500, idealHeight: 550, maxHeight: .infinity)
    }
}

struct ResultsView_Previews: PreviewProvider {
    @EnvironmentObject var networkManager:NetworkManager
    
    static var previews: some View {
        ResultsView()
    }
}
