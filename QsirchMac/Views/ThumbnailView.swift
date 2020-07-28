//
//  ThumbnailView.swift
//  QsirchMac
//
//  Created by Elliot Cater on 27/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import SwiftUI
import QuickLookThumbnailing

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


struct ThumbnailView_Previews: PreviewProvider {
    static let searchItem = SearchItem(
    id: "12345678910",
    size: 1024,
    content: "Lorem Ipsum Dolor",
    path: "Work/test.file",
    name: "test",
    itemExtension: "file",
    created: "now",
    modified: "now")
    static let url = URL(fileURLWithPath: "Work/test.file")
    static var previews: some View {
        ThumbnailView(url: url, fileDetail: searchItem)
    }
}
