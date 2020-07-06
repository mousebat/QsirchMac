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

// MARK: - Main Search View
struct SearchView: View {
    @State var searchField = ""
    var body: some View {
        VStack {
            SearchBar()
            VolumeBar()
            HSplitView() {
                List() {
                    Spacer()
                    ForEach (0..<51) { i in
                        // Navigation Link?
                        HStack(alignment: .center) {
                            //Insert Icon for File Here
                            Text("􀈿").font(Font.system(size:22)).foregroundColor(.primary)
                            VStack(alignment: .leading) {
                                Text("File Name \(i)").font(Font.system(size: 16, weight: .semibold, design: .default))
                                Text("File Path \(i)").font(Font.system(size: 12, weight: .light, design: .default))
                            }
                        }.background(Color.white)
                        Divider()
                    }
                }.frame(minWidth: 500, minHeight: 400)
                
                List() {
                    //Display Selected File Details Here
                    Text("Content")
                    Text("Content")
                    Text("Content")
                    Text("Content")
                }.frame(minWidth: 300, idealWidth: 300)
            }.background(Color.white)
        }
    }
}



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

