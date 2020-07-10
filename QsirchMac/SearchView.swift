//
//  ContentView.swift
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



// https://www.ioscreator.com/tutorials/swiftui-json-list-tutorial - THIS COULD HELP with getting codable struct from model to the list?

/*
 Get the set credentials

search(hostname: self.hostnameField, port: self.portField, searchstring: "P11121", token: self.qqsSID) { (SearchResults, ReturnedError, OtherErrors) in
    print(SearchResults!)
}
 */

// MARK: - Draw the Search Bar
struct SearchBar: View {
    @EnvironmentObject var settings: UserSettings
    // On searchfield change call function?
    
    @State var searchField = ""
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                Text("\(settings.hostname)")
                Text("􀊫").font(.largeTitle).foregroundColor(.primary)
                // On stop typing call the search function!
                TextField("Search", text: $searchField, onCommit: {
                    search(hostname: self.settings.hostname, port: self.settings.port, searchstring: self.searchField, token: self.settings.token ) { (SearchResults, ReturnedError, OtherErrors) in
                        print(SearchResults!)
                    }
                })
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
// MARK: - Draw the Volume Bar
struct VolumeBar: View {
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
    var filename: SearchResults
    var body: some View {
        VStack(alignment: .leading) {
            Text("filename.items").font(Font.system(size: 12, weight: .regular, design: .default))
        }
    }
}
// MARK: - File Detail
struct FileDetail: View {
    var fileDetail: SearchResults
    var body: some View {
        VStack {
            HStack {
                Text(" ").font(.title)
            }
        }
        .frame(minWidth: 300, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).background(Color.white)
    }
}
// MARK: - Set up the dummy data, must contain UUID to be hashable/identifiable
struct FileNames: Identifiable {
    var id = UUID()
    var name:String
}
// MARK: - Main Search View
struct SearchView: View {
    @State var searchField = " "
    @State var results = [SearchResults]()
    var body: some View {
        VStack {
            
            SearchBar()
            
            VolumeBar()
            // IF data exists show this:
            NavigationView {
                // List Data
                List(results) { file in
                    /*
                    NavigationLink(destination: FileDetail(fileDetail: file)) {
                        FileRow(filename: file)
                    }*/
                    Text("file.path")
                }.frame(minWidth: 500, minHeight: 400)
            }
            //
        }
    }
}


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

