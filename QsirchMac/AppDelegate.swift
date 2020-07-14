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
    
    var settings = UserSettings()
    var networkmanager = NetworkManager()
    
    
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
            //preferencesWindow.setFrameAutosaveName("Preferences")
            preferencesWindow.isReleasedWhenClosed = false
            preferencesWindow.contentView = NSHostingView(rootView: preferencesView.environmentObject(settings).environmentObject(networkmanager))
        }
        preferencesWindow.makeKeyAndOrderFront(nil)
    }
    
    @objc func openSearchWindow() {
        if nil == searchWindow {
            let searchView = SearchView()
            // Create the search window and set content
            searchWindow = SWindow(
                contentRect: NSRect(x: 0, y: 0, width: 850, height: 500),
                styleMask: [.resizable],
                backing: .buffered, defer: false)
            searchWindow.center()
            //searchWindow.setFrameAutosaveName("Main Window")
            searchWindow.isReleasedWhenClosed = false
            searchWindow.isMovableByWindowBackground = true
            searchWindow.titlebarAppearsTransparent = true
            searchWindow.contentView = NSHostingView(rootView: searchView.environmentObject(settings).environmentObject(networkmanager))
        }
        searchWindow.makeKeyAndOrderFront(true)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let defaults = UserDefaults.standard
        
        if let hostname = defaults.string(forKey: "hostname"),
            let port = defaults.string(forKey: "port"),
            let username = defaults.string(forKey: "username"),
            let password = defaults.string(forKey: "password") {
            networkmanager.login(hostname: hostname, port: port, username: username, password: password) { (LoginReturn, ReturnedError, HardError) in
                if let LoginReturn = LoginReturn {
                    DispatchQueue.main.async {
                        self.settings.token = LoginReturn.qqsSid
                        self.openSearchWindow()
                        
                    }
                }
                if let ReturnedError = ReturnedError, let HardError = HardError {
                    self.networkmanager.HardError = HardError
                    self.networkmanager.ReturnedErrors = ReturnedError
                    self.openPreferencesWindow()
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
    
    


