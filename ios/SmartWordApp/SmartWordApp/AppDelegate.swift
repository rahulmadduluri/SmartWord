//
//  AppDelegate.swift
//  SmartWordApp
//
//  Created by Rahul Madduluri on 3/22/20.
//  Copyright © 2020 rm. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create content view
        let contentView = ContentView().environmentObject(AppSettings())

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1200, height: 900),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        window.autorecalculatesKeyViewLoop = true
    }

}

