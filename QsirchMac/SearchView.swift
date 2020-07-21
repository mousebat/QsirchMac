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


// Returns tuple with both URL and String
func pathBuilder(path:String, name:String, ext:String?) -> (String?, URL) {
    if let ext = ext {
        var returnURL = URL(string: "/Volumes/")!.appendingPathComponent(path).appendingPathComponent(name)
        returnURL = returnURL.appendingPathExtension(ext)
        return (String(returnURL.absoluteString).removingPercentEncoding, URL(fileURLWithPath: (String(returnURL.absoluteString).removingPercentEncoding!)) )
    } else {
        let returnURL = URL(string: "/Volumes/")!.appendingPathComponent(path).appendingPathComponent(name)
        return (String(returnURL.absoluteString).removingPercentEncoding, URL(fileURLWithPath: (String(returnURL.absoluteString).removingPercentEncoding!)) )
    }
}
// Rewrite with size!  Also add fileURL
func iconGrabber(path:String, name:String, ext:String?, width:Int, height:Int) -> NSImage {
    if ext != nil {
        let rep = NSWorkspace.shared.icon(forFileType: ext!)
        // Make sure to change the Width/Height for row size!
        .bestRepresentation(for: NSRect(x: 0, y: 0, width: width, height: height), context: nil, hints: nil)
        let image = NSImage(size: rep!.size)
        image.addRepresentation(rep!)
        return image
    } else {
        let rep = NSWorkspace.shared.icon(forFile: pathBuilder(path: path, name: name, ext: ext).0!)
        // Make sure to change the Width/Height for row size!
        .bestRepresentation(for: NSRect(x: 0, y: 0, width: width, height: height), context: nil, hints: nil)
        let image = NSImage(size: rep!.size)
        image.addRepresentation(rep!)
        return image
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
        }.background(Color(.windowBackgroundColor))
    }
}

// MARK: - Draw the Search Bar
struct SearchBar: View {
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
                Text("􀊫").font(.largeTitle).foregroundColor(.primary)
                TextField("Search", text: $networkManager.searchField)
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
                Rectangle().frame(maxWidth: 0, maxHeight: .infinity)
            }.frame(minHeight:500, idealHeight: 550, maxHeight: .infinity)
        }
    }
}

// MARK: - File Row
struct FileRow: View {
    var fileRow: SearchItem
    var body: some View {
        HStack {
            if checkDriveMounted(path: self.fileRow.path) {
                VStack(alignment: .leading) {
                    Image(nsImage: iconGrabber(path: self.fileRow.path, name: self.fileRow.name, ext: self.fileRow.itemExtension!, width: 32, height: 32))
                    if FileManager.default.fileExists(atPath: pathBuilder(path: self.fileRow.path, name: self.fileRow.name, ext: self.fileRow.itemExtension).0! ) {
                        Image(nsImage: NSWorkspace.shared.icon(forFile: pathBuilder(path: self.fileRow.path, name: self.fileRow.name, ext: self.fileRow.itemExtension).0!))
                    }
                    else {
                        Text("􀍼").foregroundColor(.red).font(.title)
                    }
                }
            }
            VStack(alignment: .leading) {
                Text(fileRow.name).font(Font.system(size: 12, weight: .regular, design: .default))
                Text(pathBuilder(path: self.fileRow.path, name: self.fileRow.name, ext: self.fileRow.itemExtension).0!).font(Font.system(size: 10, weight: .regular, design: .default))
            }
        }.padding()
    }
}
// MARK: - File Detail
struct FileDetail: View {
    var fileDetail: SearchItem
    
    var body: some View {
        VStack {
            //Thumbnail here
            if FileManager.default.fileExists(atPath: pathBuilder(path: self.fileDetail.path, name: self.fileDetail.name, ext: self.fileDetail.itemExtension).0!) {
                ThumbnailView(url: pathBuilder(path: self.fileDetail.path, name: self.fileDetail.name, ext: self.fileDetail.itemExtension).1, fileDetail: fileDetail)
            }
            else {
                Text("􀍼").foregroundColor(.red).font(.title)
            }
            //File Path
            if (fileDetail.itemExtension) != nil {
                Text(fileDetail.name + "." + fileDetail.itemExtension!).font(Font.system(size: 14, weight: .semibold, design: .default))
            } else {
                Text(fileDetail.name).font(Font.system(size: 14, weight: .semibold, design: .default))
            }
            Text(fileDetail.created).font(Font.system(size: 12, weight: .regular, design: .default))
        }.frame(minWidth:250, idealWidth:300, maxWidth:.infinity, maxHeight: .infinity).background(Color.white).padding().onTapGesture(count: 2) {
            if checkDriveMounted(path: self.fileDetail.path) {
                if FileManager.default.fileExists(atPath: pathBuilder(path: self.fileDetail.path, name: self.fileDetail.name, ext: self.fileDetail.itemExtension).0! ) {
                    NSWorkspace.shared.selectFile(pathBuilder(path: self.fileDetail.path, name: self.fileDetail.name, ext: self.fileDetail.itemExtension).0, inFileViewerRootedAtPath: "")
                } else {
                    print("file does not exist")
                }
            } else {
                
                print("drive not mounted")
            }
        }.background(Color(.white))
    }
    
    
}

// MARK: - Thumbnail View
struct ThumbnailView: View {
    let url: URL
    var fileDetail: SearchItem
    @State private var thumbPresent: Bool?
    @State private var thumb: CGImage?
    
    var body: some View {
        Group {
            if thumb != nil && thumbPresent == true {
                Image(decorative: self.thumb!, scale: (NSScreen.main?.backingScaleFactor)!)
            } else {
                Image(nsImage: NSWorkspace.shared.icon(forFile: pathBuilder(path: self.fileDetail.path, name: self.fileDetail.name, ext: self.fileDetail.itemExtension).0!))
            }
        }.onAppear {
            self.generateThumbnail(url: pathBuilder(path: self.fileDetail.path, name: self.fileDetail.name, ext: self.fileDetail.itemExtension).1)
        }
    }
    
    
    func generateThumbnail(url: URL) {
        let size: CGSize = CGSize(width: 300, height: 300)
        let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: (NSScreen.main?.backingScaleFactor)!, representationTypes: .thumbnail)
        let generator = QLThumbnailGenerator.shared
        generator.generateRepresentations(for: request) { (thumbnail, type, error) in
            DispatchQueue.main.async {
                if thumbnail == nil {
                    self.thumbPresent = false
                } else {
                    self.thumb = thumbnail!.cgImage
                    self.thumbPresent = true
                }
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
