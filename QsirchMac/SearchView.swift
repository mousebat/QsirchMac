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


func openPreferencesWindow() {
    var preferencesWindow: NSWindow!
    let preferencesView = PreferencesView()
    // Create the preferences window and set content
    preferencesWindow = NSWindow(
        contentRect: NSRect(x: 20, y: 20, width: 480, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered,
        defer: false)
    preferencesWindow.center()
    preferencesWindow.setFrameAutosaveName("Preferences")
    preferencesWindow.contentView = NSHostingView(rootView: preferencesView)
    preferencesWindow.makeKeyAndOrderFront(nil)
}


// MARK: - Draw the Search Bar
struct SearchBar: View {
    @State var searchField = ""
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                Text("􀊫").font(.largeTitle).foregroundColor(.primary)
                TextField("Search", text: $searchField)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.primary)
                    .background(Color.clear)
                    .font(Font.system(size: 25, weight: .light, design: .default))
                .fixedSize()
                Spacer()
                Button(action: {
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
    var filename: FileNames
    var body: some View {
        VStack(alignment: .leading) {
            Text(filename.name).font(Font.system(size: 12, weight: .regular, design: .default))
        }
    }
}
// MARK: - File Detail
struct FileDetail: View {
    var fileDetail: FileNames
    var body: some View {
        VStack {
            HStack {
                Text(fileDetail.name).font(.title)
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
    let fileNames = [
        FileNames(name: "File Name 1"),
        FileNames(name: "File Name 2"),
        FileNames(name: "File Name 3"),
        FileNames(name: "File Name 4"),
        FileNames(name: "File Name 5"),
        FileNames(name: "File Name 6"),
        FileNames(name: "File Name 7"),
        FileNames(name: "File Name 8"),
        FileNames(name: "File Name 9"),
        FileNames(name: "File Name 10"),
    ]
    @State var searchField = " "
    var body: some View {
        VStack {
            SearchBar()
            VolumeBar()
            NavigationView {
                List(fileNames) { file in
                    NavigationLink(destination: FileDetail(fileDetail: file)) {
                        FileRow(filename: file)
                    }
                }.frame(minWidth: 500, minHeight: 400)
            }
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

