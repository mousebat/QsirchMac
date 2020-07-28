//
//  FileDetailView.swift
//  QsirchMac
//
//  Created by Elliot Cater on 27/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import SwiftUI

// MARK: - File Detail
struct FileDetailView: View {
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

struct FileDetailView_Previews: PreviewProvider {
    static let searchItem = SearchItem(
    id: "12345678910",
    size: 1024,
    content: "Lorem Ipsum Dolor",
    path: "Work/test.file",
    name: "test",
    itemExtension: "file",
    created: "now",
    modified: "now")
    
    static var previews: some View {
        FileDetailView(fileDetail: searchItem)
    }
}
