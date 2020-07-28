//
//  SearchBarView.swift
//  QsirchMac
//
//  Created by Elliot Cater on 27/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import SwiftUI

// MARK: - Draw the Search Bar
struct SearchBarView: View {
    @EnvironmentObject var networkManager:NetworkManager
    
    // Drive Selector
    var driveProxy:Binding<String> {
        Binding<String>(get: { self.networkManager.drive }, set: {
            self.networkManager.drive = $0
            self.commitSearch()
        })
    }
    // Results Selector
    var resultsProxy:Binding<String> {
        Binding<String>(get: { self.networkManager.results }, set: {
            self.networkManager.results = $0
            self.commitSearch()
        })
    }
    // Sort By Selector
    var sortbyProxy:Binding<String> {
        Binding<String>(get: { self.networkManager.sortby }, set: {
            self.networkManager.sortby = $0
            self.commitSearch()
        })
    }
    // Sort Direction Selector
    var sortdirProxy:Binding<String> {
        Binding<String>(get: { self.networkManager.sortdir }, set: {
            self.networkManager.sortdir = $0
            self.commitSearch()
        })
    }
    // Commit Search
    private func commitSearch() -> Void {
        self.networkManager.search(searchstring: self.networkManager.searchField,
                                   path: self.networkManager.drive,
                                   results: self.networkManager.results,
                                   sortby: self.networkManager.sortby,
                                   sortdir: self.networkManager.sortdir)
    }
        
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                Text("􀊫").font(.largeTitle).foregroundColor(Color(.darkGray))
                TextField("Search", text: $networkManager.searchField)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(Color(.darkGray))
                    .font(Font.system(size: 25, weight: .light, design: .default))
                    .fixedSize()
                Spacer()
                Button(action: {
                    NSApp.sendAction(#selector(AppDelegate.openPreferencesWindow), to: nil, from:nil)
                }) {
                    Text("􀍟").font(.largeTitle).foregroundColor(Color(.darkGray))
                }.buttonStyle(PlainButtonStyle())
            }.padding([.top, .leading, .trailing], 20.0)
            Divider()
            HStack(alignment: .center) {
                if (networkManager.drivesToDisplay == true){
                    ScrollView(.horizontal) {
                        Picker(selection: driveProxy, label: Text("Select Drive")) {
                            Text("All").tag("All")
                            
                            ForEach(networkManager.DrivesList!.items){ drivename in
                                Text(drivename.name).tag(drivename.name)
                            }
                            
                        }.pickerStyle(SegmentedPickerStyle()).labelsHidden().frame(alignment: .leading)
                    }
                }
                Spacer()
                Picker(selection: resultsProxy, label: Text("Results")) {
                    Text("Results").tag("25")
                    Text("50").tag("50")
                    Text("100").tag("100")
                    Text("200").tag("200")
                }.pickerStyle(PopUpButtonPickerStyle()).labelsHidden().frame(width: 85)
                Divider().frame(height: 20)
                Picker(selection: sortbyProxy, label: Text("Sort By")) {
                    Text("Sort By").tag("relevance")
                    Text("Name").tag("name")
                    Text("Size").tag("size")
                    Text("Extension").tag("extension")
                    Text("Modified").tag("modified")
                }.pickerStyle(PopUpButtonPickerStyle()).labelsHidden().frame(width: 85)
                Divider().frame(height: 20)
                Picker(selection: sortdirProxy, label: Text("Sort 􀄬")) {
                    Text("Sort 􀄬").tag("default")
                    Text("Desc 􀄩").tag("desc")
                    Text("Asc 􀄨").tag("asc")
                }.pickerStyle(PopUpButtonPickerStyle()).labelsHidden().frame(width: 85)
                }.padding(.horizontal)
            Divider()
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView().environmentObject(NetworkManager())
    }
}
