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
    
    
    
    
    var searchWindow: SWindow!
    
    var preferencesWindow: NSWindow!    // << here
    
    var settings = UserSettings()

    
    @objc func openPreferencesWindow() {
        if nil == preferencesWindow {      // create once !!
            let preferencesView = PreferencesView()
            // Create the preferences window and set content
            preferencesWindow = NSWindow(
                contentRect: NSRect(x: 20, y: 20, width: 480, height: 300),
                styleMask: [.titled, .miniaturizable, .fullSizeContentView],
                backing: .buffered,
                defer: false)
            preferencesWindow.center()
            preferencesWindow.setFrameAutosaveName("Preferences")
            preferencesWindow.isReleasedWhenClosed = false
            preferencesWindow.contentView = NSHostingView(rootView: preferencesView.environmentObject(settings))
        }
        preferencesWindow.makeKeyAndOrderFront(nil)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        /* Remove Defaults whilst debugging
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        */
        
        // Create the SwiftUI view that provides the window contents.
        let searchView = SearchView()
        
        // Create the window and set the content view.
        searchWindow = SWindow(
            contentRect: NSRect(x: 0, y: 0, width: 850, height: 500),
            styleMask: [.resizable],
            backing: .buffered, defer: false)
        searchWindow.center()
        searchWindow.setFrameAutosaveName("Main Window")
        searchWindow.contentView = NSHostingView(rootView: searchView.environmentObject(settings))
        searchWindow.makeKeyAndOrderFront(true)
        searchWindow.isMovableByWindowBackground = true
        searchWindow.titlebarAppearsTransparent = true
        

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    

}
