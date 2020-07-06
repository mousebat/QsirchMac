//
//  AppDelegate.swift
//  QsirchMac
//
//  Created by Elliot Cater on 03/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Cocoa
import SwiftUI

// MARK: - Override search Window
class SWindow: NSWindow {
    override var canBecomeKey:Bool {
        return true
    }
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: SWindow!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let searchView = SearchView()

        // Create the window and set the content view.
        window = SWindow(
            contentRect: NSRect(x: 0, y: 0, width: 850, height: 500),
            styleMask: [.resizable],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: searchView)
        window.makeKeyAndOrderFront(nil)
        window.isMovableByWindowBackground = true
        window.titlebarAppearsTransparent = true
    }
    

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    

}