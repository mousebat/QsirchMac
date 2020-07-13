//
//  SearchView.swift
//  QsirchMac
//
//  Created by Elliot Cater on 03/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import SwiftUI

// This extension removes the focus ring entirely.
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
// MARK: - Draw the Search Bar
struct SearchBar: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var networkManager:NetworkManager
    
    @State var searchField = ""
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                Text("􀊫").font(.largeTitle).foregroundColor(.primary)
                // On stop typing call the search function!
                TextField("Search", text: $searchField, onCommit: {
                    self.networkManager.search(hostname: self.settings.hostname,
                                               port: self.settings.port,
                                               searchstring: self.searchField,
                                               token: self.settings.token) })
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.primary)
                    .background(Color.clear)
                    .font(Font.system(size: 25, weight: .light, design: .default))
                    .fixedSize()
                Spacer()
                
                Button(action: {
                    NSApplication.shared.keyWindow?.close()
                    NSApp.sendAction(#selector(AppDelegate.openPreferencesWindow), to: nil, from:nil)
                }) {
                    Text("􀍟").font(.largeTitle).foregroundColor(.primary)
                }.buttonStyle(PlainButtonStyle())
            }
            .foregroundColor(.secondary)
            .padding([.top, .leading, .trailing], 20.0)
            .background(Color.clear)
        }
    }
}
// MARK: - Draw the Volume Bar - needs to be replaced with single selection UI also add a results drop down
struct OptionBar: View {
    @State private var thisToggle:Bool = false
    @State private var thatToggle:Bool = false
    @State private var theotherToggle:Bool = false
    var body: some View {
        VStack {
            Divider()
            HStack(alignment: .center) {
                ScrollView(.horizontal) {
                    Picker(selection: .constant(0), label: Text("Select Drive")) {
                        Text("All").tag(0)
                        Text("Work").tag(1)
                        Text("Production").tag(2)
                        Text("Admin").tag(3)
                    }.pickerStyle(SegmentedPickerStyle()).labelsHidden().frame(alignment: .leading)
                }
                Spacer()
                Picker(selection: .constant(0), label: Text("Results")) {
                    Text("Results").tag(0)
                    Text("25").tag(1)
                    Text("50").tag(2)
                    Text("100").tag(3)
                    Text("200").tag(4)
                    }.pickerStyle(PopUpButtonPickerStyle()).labelsHidden().frame(width: 85)
                Divider().frame(height: 20)
                Picker(selection: .constant(0), label: Text("Sort By")) {
                    Text("Sort By").tag(0)
                    Text("Relevance").tag(1)
                    Text("Name").tag(2)
                    Text("Size").tag(3)
                    Text("Extension").tag(4)
                    Text("Modified").tag(4)
                }.pickerStyle(PopUpButtonPickerStyle()).labelsHidden().frame(width: 85)
                Divider().frame(height: 20)
                Picker(selection: .constant(0), label: Text("Sort 􀄬")) {
                    Text("Sort 􀄬").tag(0)
                    Text("Desc 􀄩").tag(1)
                    Text("Asc 􀄨").tag(2)
                }.pickerStyle(PopUpButtonPickerStyle()).labelsHidden().frame(width: 85)
            }.padding(.horizontal)
            Divider()
        }
    }
}
// MARK: - File Row
struct FileRow: View {
    var fileRow: Item
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(fileRow.name).font(Font.system(size: 12, weight: .regular, design: .default))
                Text(fileRow.path).font(Font.system(size: 12, weight: .regular, design: .default))
            }
        }
    }
}
// MARK: - File Detail
struct FileDetail: View {
    var fileDetail: Item
    var body: some View {
        HStack {
            VStack {
                Text(fileDetail.name).font(.title)
                Text(fileDetail.created).font(Font.system(size: 12, weight: .regular, design: .default))
            }.background(Color.white).frame(minWidth:250, idealWidth:300, maxHeight: .infinity)
        }
    }
}
// MARK: - Search Results
struct ResultsView: View {
    @EnvironmentObject var networkManager:NetworkManager
    var body: some View {
        VStack {
            
            if (networkManager.filesToDisplay == true){
                NavigationView {
                    List(networkManager.FileList!.items) { file in
                        NavigationLink(destination: FileDetail(fileDetail: file)) {
                            FileRow(fileRow: file)
                        }
                    }
                }.frame(minHeight:300).background(Color.white)
            }
            if (networkManager.FileList?.total == 0) {
                HStack {
                    Text("No Results Found")
                }
            }
                
        }
    }
}
// MARK: - Main Search View
struct SearchView: View {
    //@EnvironmentObject var networkManager:NetworkManager
    @State var searchField = " "
    
    var body: some View {
        VStack {
            SearchBar()
            OptionBar()
            ResultsView()
        }
    }
}

// MARK: - Preview Loader
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView().environmentObject(NetworkManager()).environmentObject(UserSettings())
        
    }
}
