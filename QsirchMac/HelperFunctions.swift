//
//  HelperFunctions.swift
//  QsirchMac
//
//  Created by Elliot Cater on 24/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Foundation
import SwiftUI

// This extension removes the focus ring entirely.
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
// Overide white table list
extension NSTableView {
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        backgroundColor = .clear
        enclosingScrollView?.drawsBackground = false
        enclosingScrollView?.backgroundColor = .clear
        enclosingScrollView?.autohidesScrollers = true
    }
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
