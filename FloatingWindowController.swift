//
//  FloatingWindowController.swift
//  NewFileMenu
//
//  Created by Juhen Ahmed on 3/5/26.
//


import SwiftUI
import AppKit

final class FloatingWindowController: NSWindowController {
    
    /// A reference to the window we are controlling
    private var panel: NSPanel?
    
    init(rootView: AnyView) {
        // 1. Create an NSPanel (a subclass of NSWindow optimized for utility UI)
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 120),
            styleMask: [.nonactivatingPanel, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        // 2. Configure Appearance & Behavior
        panel.isFloatingPanel = true
        panel.level = .mainMenu // Keeps it above standard windows
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isMovableByWindowBackground = true
        panel.isReleasedWhenClosed = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        
        // 3. Host the SwiftUI View
        let hostingView = NSHostingView(rootView: rootView)
        panel.contentView = hostingView
        
        self.panel = panel
        super.init(window: panel)
        
        // Center it on the current screen
        panel.center()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Shows the window and makes it the primary focus
    func show() {
        guard let panel = self.panel else { return }
        panel.center()
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    /// Hides the window without destroying the object
    func hide() {
        panel?.orderOut(nil)
    }
}