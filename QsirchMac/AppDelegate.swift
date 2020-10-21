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
    
    var statusBarItem: NSStatusItem!
    
    var searchWindow: SWindow!
    
    var preferencesWindow: NSWindow!
    
    var networkManager = NetworkManager()
    
    
    @objc func openPreferencesWindow() {
        NSApplication.shared.keyWindow?.close() // Close current window
        if nil == preferencesWindow {      // creates once
            let preferencesView = PreferencesView()
            preferencesWindow = NSWindow(
                contentRect: NSRect(x: 20, y: 20, width: 480, height: 300),
                styleMask: [.titled, .miniaturizable, .fullSizeContentView],
                backing: .buffered,
                defer: false)
            preferencesWindow.center()
            preferencesWindow.isReleasedWhenClosed = false
            preferencesWindow.level = .floating
            preferencesWindow.contentView = NSHostingView(rootView: preferencesView.environmentObject(networkManager))
        }
        preferencesWindow.makeKeyAndOrderFront(nil)
    }
    
    @objc func openSearchWindow() {
        NSApplication.shared.keyWindow?.close() // Close current window
        if nil == searchWindow {      // creates once
            let searchView = SearchView().cornerRadius(10)
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
            searchWindow.collectionBehavior = [.canJoinAllSpaces, .transient]
            searchWindow.contentView = NSHostingView(rootView: searchView.environmentObject(networkManager))
        }
        searchWindow.makeKeyAndOrderFront(true)
    }
    
    // Toggle Window Visibility
    @objc func toggleSearchWindow(sender: NSStatusBarButton) {
        var prefsOpen:Bool = false
        if self.preferencesWindow != nil {
            if self.preferencesWindow.isVisible {
                prefsOpen = true
            }
        }
        if self.searchWindow != nil && prefsOpen == false {
            if self.searchWindow.isVisible {
                self.searchWindow.setIsVisible(false)
            } else {
                NSApp.activate(ignoringOtherApps: true)
                self.searchWindow.setIsVisible(true)
                self.searchWindow.contentViewController?.view.window?.becomeKey()
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        if (osVersion.minorVersion == 15 || osVersion.minorVersion == 14) {
            // Create status bar item
            self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
            if let button = self.statusBarItem.button {
                button.image = NSImage(named: "QsirchStatusBarIcon")
                button.action = #selector(toggleSearchWindow(sender:))
            }
            
            let defaults = UserDefaults.standard
            
            if let hostname = defaults.string(forKey: "hostname"),
                let port = defaults.string(forKey: "port"),
                let username = defaults.string(forKey: "username"),
                let password = defaults.string(forKey: "password") {
                networkManager.login(hostname: hostname, port: port, username: username, password: password)
                if networkManager.ErrorReturned != nil {
                    DispatchQueue.main.async {
                        self.openPreferencesWindow()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.openSearchWindow()
                    }
                }
            } else {
                self.openPreferencesWindow()
            }
        } else {
            //hard exit if not catalina
            exit(1)
        }
    }
    
    
    
    func applicationDidResignActive(_ notification: Notification) {
        if self.searchWindow != nil {
            self.searchWindow.setIsVisible(false)
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
    
    


