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
            HStack(alignment: .center, spacing: 20) {
                Toggle(isOn: $thisToggle){
                   Text("This Drive")
                }.toggleStyle(SwitchToggleStyle())
                Divider().frame(height: 20)
                Toggle(isOn: $thatToggle){
                   Text("That Drive")
                      
                }.toggleStyle(SwitchToggleStyle())
                Divider().frame(height: 20)
                Toggle(isOn: $theotherToggle){
                   Text("The Other Drive")
                      
                }.toggleStyle(SwitchToggleStyle())
                Divider().frame(height: 20)
                Spacer()
            }.padding(.horizontal)
        }
    }
}
// MARK: - File Row
struct FileRow: View {
    var fileRow: Item
    var body: some View {
        VStack(alignment: .leading) {
            Text(fileRow.name).font(Font.system(size: 12, weight: .regular, design: .default))
            Text(fileRow.path).font(Font.system(size: 12, weight: .regular, design: .default))
        }
    }
}
// MARK: - File Detail
struct FileDetail: View {
    var fileDetail: Item
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(fileDetail.name).font(.title)
                    Text(fileDetail.created).font(Font.system(size: 12, weight: .regular, design: .default))
                }
            }
        }
        .frame(minWidth: 300, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).background(Color.white)
    }
}

// MARK: - Main Search View
struct SearchView: View {
    @EnvironmentObject var networkManager:NetworkManager
    @State var searchField = " "
    
    
    
    var body: some View {
        VStack {
            
            SearchBar()
            
            OptionBar()
            // IF data exists show this:
            if (networkManager.filesToDisplay == true){
                NavigationView {
                    // List Data
                    List(networkManager.FileList!.items) { file in
                        NavigationLink(destination: FileDetail(fileDetail: file)) {
                            FileRow(fileRow: file)
                        }
                    }
                }.frame(minWidth: 500, minHeight: 400)
            }
                
        }
    }
}
                //Text(networkManager.FileList?.items[0].name ?? "null")

// MARK: - Preview Loader
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
        SearchBar()
        VolumeBar()
        //SearchView()
        }
    }
}

