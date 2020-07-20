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
    
    var preferencesWindow: NSWindow!
    
    var networkManager = NetworkManager()
    
    
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
            preferencesWindow.isReleasedWhenClosed = false
            preferencesWindow.contentView = NSHostingView(rootView: preferencesView.environmentObject(networkManager))
        }
        preferencesWindow.makeKeyAndOrderFront(nil)
    }
    
    @objc func openSearchWindow() {
        if nil == searchWindow {
            let searchView = SearchView().cornerRadius(10)
            // Create the search window and set content
            searchWindow = SWindow(
                contentRect: NSRect(x: 0, y: 0, width: 850, height: 500),
                styleMask: [.resizable, .fullSizeContentView],
                backing: .buffered, defer: false)
            searchWindow.center()
            searchWindow.isReleasedWhenClosed = false
            searchWindow.isMovableByWindowBackground = true
            searchWindow.titlebarAppearsTransparent = true
            searchWindow.isOpaque = false
            searchWindow.backgroundColor = NSColor.clear
            searchWindow.contentView = NSHostingView(rootView: searchView.environmentObject(networkManager))
        }
        searchWindow.makeKeyAndOrderFront(true)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let defaults = UserDefaults.standard
        
        if let hostname = defaults.string(forKey: "hostname"),
            let port = defaults.string(forKey: "port"),
            let username = defaults.string(forKey: "username"),
            let password = defaults.string(forKey: "password") {
            networkManager.login(hostname: hostname, port: port, username: username, password: password) { (LoginReturn, ErrorReturned, HardError) in
                if let ErrorReturned = ErrorReturned, let HardError = HardError {
                    DispatchQueue.main.async {
                        self.networkManager.HardError = HardError
                        self.networkManager.ErrorReturned = ErrorReturned
                        self.openPreferencesWindow()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.openSearchWindow()
                    }
                }
            }
        } else {
            self.openPreferencesWindow()
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
    
    


