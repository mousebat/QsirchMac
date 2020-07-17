//
//  SearchView.swift
//  QsirchMac
//
//  Created by Elliot Cater on 03/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import SwiftUI
import QuickLookThumbnailing


// This extension removes the focus ring entirely.
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

let previewGenerator = QLThumbnailGenerator()



func pathBuilder(path:String, name:String, ext:String?) -> String? {
    if let ext = ext {
        var returnURL = URL(string: "/Volumes/")!.appendingPathComponent(path).appendingPathComponent(name)
        returnURL = returnURL.appendingPathExtension(ext)
        return String(returnURL.absoluteString).removingPercentEncoding
    } else {
        let returnURL = URL(string: "/Volumes/")!.appendingPathComponent(path).appendingPathComponent(name)
        return String(returnURL.absoluteString).removingPercentEncoding
    }
}

func iconGrabber(path:String, name:String, ext:String?) -> NSImage! {
    if let builtPath = pathBuilder(path: path, name: name, ext: ext) {
        if let rep = NSWorkspace.shared.icon(forFile: "/Volumes/\(builtPath)")
            // Make sure to change the Width/Height for row size!
            .bestRepresentation(for: NSRect(x: 0, y: 0, width: 32, height: 32), context: nil, hints: nil) {
            let image = NSImage(size: rep.size)
            image.addRepresentation(rep)
            return image
        } else {
            return nil
        }
    } else {
        return nil
    }
}


func checkDriveMounted(path:String) -> Bool {
    //let fullPath = URL(string: path)
    let split = path.components(separatedBy: "/")
    let firstComponent = split[0]
    // Check what volumes are mounted! - Usefull!
    let filemanager:FileManager = FileManager()
    let keys = [URLResourceKey.volumeNameKey, URLResourceKey.volumeIsRemovableKey, URLResourceKey.volumeIsEjectableKey]
    let paths = filemanager.mountedVolumeURLs(includingResourceValuesForKeys: keys, options: [.skipHiddenVolumes])
    var urlArray = [String]()
    if var urls = paths as [URL]? {
        urls.removeFirst()
        for url in urls {
            urlArray.append(url.pathComponents[2])
        }
    }
    if urlArray.contains(firstComponent) {
        return true
    } else {
        return false
    }
    
}

// MARK: - Draw the Search Bar
struct SearchBar: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var networkManager:NetworkManager
    
    // Drive Selector
    @State var drive = "All"
    private var driveProxy:Binding<String> {
        Binding<String>(get: { self.drive }, set: {
            self.drive = $0
            self.commitSearch()
        })
    }
    // Results Selector
    @State var results = "25"
    private var resultsProxy:Binding<String> {
        Binding<String>(get: { self.results }, set: {
            self.results = $0
            self.commitSearch()
        })
    }
    // Sort By Selector
    @State var sortby = "relevance"
    private var sortbyProxy:Binding<String> {
        Binding<String>(get: { self.sortby }, set: {
            self.sortby = $0
            self.commitSearch()
        })
    }
    // Sort Direction Selector
    @State var sortdir:String = "default"
    private var sortdirProxy:Binding<String> {
        Binding<String>(get: { self.sortdir }, set: {
            self.sortdir = $0
            self.commitSearch()
        })
    }
    // No way to sort binding debounce
    /* Sort Direction Selector
    @State var searchField:String = ""
    private var searchfieldProxy:Binding<String> {
        Binding<String>(get: { self.searchField }, set: {
            self.searchField = $0
            self.commitSearch()
        })
    }
 */
    @State var searchField:String = ""
    
    private func commitSearch() -> Void {
        //if (self.searchField != "") {
            self.networkManager.search(hostname: self.settings.hostname,
                port: self.settings.port,
                searchstring: self.searchField,
                token: self.settings.token, path: self.drive, results: self.results, sortby: self.sortby, sortdir: self.sortdir)
        //}
    }
        
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                Text("􀊫").font(.largeTitle).foregroundColor(.primary).onTapGesture {
                    self.commitSearch()
                }
                // On stop typing call the search function!
                TextField("Search", text: $searchField)
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

// MARK: - File Row
struct FileRow: View {
    var fileRow: SearchItem
    var body: some View {
        HStack(alignment: .center) {
            if checkDriveMounted(path: self.fileRow.path) {
                if FileManager.default.fileExists(atPath: pathBuilder(path: self.fileRow.path, name: self.fileRow.name, ext: self.fileRow.itemExtension)!) {
                        //ADD Image from path with getIcon()
                        VStack(alignment: .leading) {
                            Image(nsImage: iconGrabber(path: self.fileRow.path, name: self.fileRow.name, ext: self.fileRow.itemExtension))
                        }
                    } else {
                    // DEFAULT IMAGE
                }
            }
            VStack(alignment: .leading) {
                Text(fileRow.name).font(Font.system(size: 12, weight: .regular, design: .default))
                Text(fileRow.path+"/"+fileRow.name).font(Font.system(size: 10, weight: .regular, design: .default))
            }
        }.padding()
    }
}
// MARK: - File Detail
struct FileDetail: View {
    var fileDetail: SearchItem
    
    var body: some View {
        VStack {
            if (fileDetail.itemExtension) != nil {
                Text(fileDetail.name + "." + fileDetail.itemExtension!).font(Font.system(size: 14, weight: .semibold, design: .default))
            } else {
                Text(fileDetail.name).font(Font.system(size: 14, weight: .semibold, design: .default))
            }
            Text(fileDetail.created).font(Font.system(size: 12, weight: .regular, design: .default))
        }.frame(minWidth:250, idealWidth:300, maxWidth:.infinity, maxHeight: .infinity).background(Color.white).padding().onTapGesture(count: 2) {
            
            if checkDriveMounted(path: self.fileDetail.path) {
                if FileManager.default.fileExists(atPath: pathBuilder(path: self.fileDetail.path, name: self.fileDetail.name, ext: self.fileDetail.itemExtension)! ) {
                    NSWorkspace.shared.selectFile(pathBuilder(path: self.fileDetail.path, name: self.fileDetail.name, ext: self.fileDetail.itemExtension), inFileViewerRootedAtPath: "")
                } else {
                    print("file does not exist")
                }
            } else {
                print("drive not mounted")
            }
        }
    }
}
// MARK: - Search Results
struct ResultsView: View {
    @EnvironmentObject var networkManager:NetworkManager
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(networkManager.FileList!.items) { file in
                        NavigationLink(destination: FileDetail(fileDetail: file)) {
                            FileRow(fileRow: file)
                        }
                    }
                }.frame(minWidth: 400, maxWidth: .infinity, alignment: .leading)
            }.frame(minHeight:500).background(Color.white)
        }
    }
}
// MARK: - Main Search View
struct SearchView: View {
    @EnvironmentObject var networkManager:NetworkManager
    
    var body: some View {
        VStack {
            SearchBar()
            if networkManager.filesToDisplay {
                ResultsView()
            }
            if (networkManager.FileList?.total == 0) {
                HStack {
                    Text("No Results Found").font(.headline)
                }.padding()
            }
            if (networkManager.ErrorReturned?.error.message != nil) {
                HStack {
                    Text("\(networkManager.ErrorReturned?.error.message ?? "Unknown Error")").font(.headline)
                }.padding()
            }
        }
    }
}

// MARK: - Preview Loader
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView().environmentObject(NetworkManager()).environmentObject(UserSettings())
    }
}
