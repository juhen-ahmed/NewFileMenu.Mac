//
//  MenuBarManager.swift
//  NewFileMenu
//
//  Created by Juhen Ahmed on 2/5/26.
//

import Foundation
import Cocoa

class MenuBarManager {
    private var statusItem: NSStatusItem!

    init() {
        setupMenuBar()
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "doc.badge.plus", accessibilityDescription: "New File Menu")
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit New File Menu", action: #selector(quitApp), keyEquivalent: "q"))
        
        statusItem.menu = menu
        
        for item in menu.items {
            item.target = self
        }
    }

    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}



