//
//  FileRowView.swift
//  QsirchMac
//
//  Created by Elliot Cater on 27/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import SwiftUI

// MARK: - File Row
struct FileRowView: View {
    var fileRow: SearchItem
    @State var alertStatus:Bool = false
    @State var alertHeader:String = ""
    @State var alertMessage:String = ""
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
                }.onTapGesture(count: 2) {
                    if checkDriveMounted(path: self.fileRow.path) {
                        if FileManager.default.fileExists(atPath: pathBuilder(path: self.fileRow.path, name: self.fileRow.name, ext: self.fileRow.itemExtension).0! ) {
                            NSWorkspace.shared.selectFile(pathBuilder(path: self.fileRow.path, name: self.fileRow.name, ext: self.fileRow.itemExtension).0, inFileViewerRootedAtPath: "")
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
                }
            }
            VStack(alignment: .leading) {
                Text(fileRow.name).font(Font.system(size: 12, weight: .regular, design: .default))
                Text(fileRow.path).font(Font.system(size: 8, weight: .light, design: .default))
                
            }
        }.frame(minWidth: 400, maxWidth: .infinity, alignment: .leading).alert(isPresented: $alertStatus) {
            Alert(title: Text(alertHeader), message: Text(alertMessage))
        }
    }
}
struct FileRowView_Previews: PreviewProvider {
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
        FileRowView(fileRow: searchItem)
    }
}

