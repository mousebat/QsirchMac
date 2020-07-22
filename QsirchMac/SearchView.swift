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
// Overide stupid white list
extension NSTableView {
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        backgroundColor = .clear
        enclosingScrollView?.drawsBackground = false
        enclosingScrollView?.backgroundColor = .clear
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
// Returns NSImage for icon at path
func iconGrabber(path:String, name:String, ext:String?, width:Int, height:Int) -> NSImage {
    let builtPath = pathBuilder(path: path, name: name, ext: ext)
    let rep = NSWorkspace.shared.icon(forFile: builtPath.0!).bestRepresentation(for: NSRect(x: 0, y: 0, width: width, height: height), context: nil, hints: nil)
    let image = NSImage(size: rep!.size)
    image.addRepresentation(rep!)
    return image
}
// Returns true if drive mounted for path
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
func formatBytes(bytes:Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.countStyle = .file
        formatter.includesUnit = true
        formatter.isAdaptive = true
        let returnBytes = formatter.string(fromByteCount: Int64(bytes)) // '123.46 GB'
        return returnBytes
}


struct VisualEffectView: NSViewRepresentable
{
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView
    {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context)
    {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}
// MARK: - Main Search View
struct SearchView: View {
    @EnvironmentObject var networkManager:NetworkManager
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar().background(Color(.windowBackgroundColor)).cornerRadius(0)//corner radius override - stops the weird double corner at the bottom of search bar!
            if networkManager.filesToDisplay {
                ResultsView().background(VisualEffectView(material: NSVisualEffectView.Material.popover, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))
            }
            if (networkManager.FileList?.total == 0) {
                HStack {
                    Text("No Results Found").font(.headline)
                }.padding().background(VisualEffectView(material: NSVisualEffectView.Material.popover, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))

            }
            if (networkManager.ErrorReturned?.error.message != nil) {
                HStack {
                    Text("\(networkManager.ErrorReturned?.error.message ?? "Unknown Error")").font(.headline)
                }.padding().background(VisualEffectView(material: NSVisualEffectView.Material.popover, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))

            }
        }
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
                Text("􀊫").font(.largeTitle).foregroundColor(Color(.darkGray))
                TextField("Search", text: $networkManager.searchField)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(Color(.darkGray))
                    .font(Font.system(size: 25, weight: .light, design: .default))
                    .fixedSize()
                Spacer()
                Button(action: {
                    NSApplication.shared.keyWindow?.close()
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

// MARK: - Search Results
struct ResultsView: View {
    @EnvironmentObject var networkManager:NetworkManager
    var body: some View {
        NavigationView {
            List {
                ForEach(networkManager.FileList!.items) { file in
                    NavigationLink(destination: FileDetail(fileDetail: file)) {
                        FileRow(fileRow: file)
                    }
                }
            }
            Rectangle().frame(maxWidth: 0, maxHeight: .infinity)
        }.frame(minHeight:500, idealHeight: 550, maxHeight: .infinity)
    }
}



// MARK: - File Row
struct FileRow: View {
    var fileRow: SearchItem
    var body: some View {
        HStack {
            if checkDriveMounted(path: self.fileRow.path) {
                VStack(alignment: .leading) {
                    if FileManager.default.fileExists(atPath: pathBuilder(path: self.fileRow.path, name: self.fileRow.name, ext: self.fileRow.itemExtension).0! ) {
                        Image(nsImage: iconGrabber(path: self.fileRow.path, name: self.fileRow.name, ext: self.fileRow.itemExtension, width: 32, height: 32))
                    }
                    else {
                        Text("􀍼").foregroundColor(.red).font(.title)
                    }
                }
            }
            VStack(alignment: .leading) {
                Text(fileRow.name).font(Font.system(size: 12, weight: .regular, design: .default))
                Text(fileRow.path).font(Font.system(size: 8, weight: .light, design: .default))
                
            }
        }.frame(minWidth: 400, maxWidth: .infinity, alignment: .leading)
        
    }
}
// MARK: - File Detail
struct FileDetail: View {
    var fileDetail: SearchItem
    
    @State var alertStatus:Bool = false
    @State var alertHeader:String = ""
    @State var alertMessage:String = ""
    
    
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                //Thumbnail here
                if FileManager.default.fileExists(atPath: pathBuilder(path: self.fileDetail.path, name: self.fileDetail.name, ext: self.fileDetail.itemExtension).0!) {
                    ThumbnailView(url: pathBuilder(path: self.fileDetail.path, name: self.fileDetail.name, ext: self.fileDetail.itemExtension).1, fileDetail: fileDetail)
                }
                else {
                    Text("􀍼").foregroundColor(.red).font(Font.system(size: 48, weight: .regular, design: .default))
                }
            }
            Spacer()
            VStack {
                Divider()
                Text(fileDetail.name).font(Font.system(size: 14, weight: .regular, design: .default)).multilineTextAlignment(.center).padding(.vertical).foregroundColor(Color(.black))
            }
            
            HStack(spacing:2) {
                Spacer()
                Text("Size: ").font(Font.system(size: 11, weight: .regular, design: .default)).foregroundColor(Color(.darkGray))
                Text(formatBytes(bytes: fileDetail.size)).font(Font.system(size: 11, weight: .regular, design: .default)).foregroundColor(Color(.black))
                Spacer()
            
            }
            HStack(spacing:2) {
                Spacer()
                Text("Date Modified: ").font(Font.system(size: 11, weight: .regular, design: .default)).foregroundColor(Color(.darkGray))
                Text(fileDetail.modified).font(Font.system(size: 11, weight: .regular, design: .default)).foregroundColor(Color(.black))
                Spacer()
            }
            HStack(spacing:2) {
                Spacer()
                Text("Date Created: ").font(Font.system(size: 11, weight: .regular, design: .default)).foregroundColor(Color(.darkGray))
                Text(fileDetail.created).font(Font.system(size: 11, weight: .regular, design: .default)).foregroundColor(Color(.black))
                Spacer()
            }
            if (fileDetail.content?.count != nil) {
                VStack {
                    Text("Content:").font(Font.system(size: 11, weight: .regular, design: .default)).foregroundColor(Color(.darkGray))
                    Text(fileDetail.content ?? "N/A").font(Font.system(size: 12, weight: .regular, design: .default)).multilineTextAlignment(.center).font(Font.system(size: 11, weight: .regular, design: .default)).foregroundColor(Color(.black))
                }.padding()
            }
            
        }.frame(minWidth:350, idealWidth:350, maxWidth:.infinity, maxHeight: .infinity).padding().onTapGesture(count: 2) {
            if checkDriveMounted(path: self.fileDetail.path) {
                if FileManager.default.fileExists(atPath: pathBuilder(path: self.fileDetail.path, name: self.fileDetail.name, ext: self.fileDetail.itemExtension).0! ) {
                    NSWorkspace.shared.selectFile(pathBuilder(path: self.fileDetail.path, name: self.fileDetail.name, ext: self.fileDetail.itemExtension).0, inFileViewerRootedAtPath: "")
                } else {
                    self.alertStatus = true
                    self.alertHeader = "File Missing"
                    self.alertMessage = "The file is missing at this location."
                }
            } else {
                    self.alertStatus = true
                    self.alertHeader = "Drive Missing"
                    self.alertMessage = "The drive for this file is not mounted, please mount and try again."
                            
            }
        }.alert(isPresented: $alertStatus) {
            Alert(title: Text(alertHeader), message: Text(alertMessage))
        }
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
                Image(decorative: self.thumb!, scale: (NSScreen.main?.backingScaleFactor)!).resizable()
                .aspectRatio(contentMode: .fit)
            } else {
                Image(nsImage: iconGrabber(path: fileDetail.path, name: fileDetail.name, ext: fileDetail.itemExtension, width: 64, height: 64)).resizable()
                .aspectRatio(contentMode: .fit)
            }
        }.onAppear {
            self.generateThumbnail(url: pathBuilder(path: self.fileDetail.path, name: self.fileDetail.name, ext: self.fileDetail.itemExtension).1)
        }
    }
    
    
    func generateThumbnail(url: URL) {
        let size: CGSize = CGSize(width: 500, height: 500)
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
