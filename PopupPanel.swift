//
//  PopupPanel.swift
//  NewFileMenu
//
//  Created by Juhen Ahmed on 2/5/26.
//


import SwiftUI
import AppKit

class PopupPanel: NSPanel {
    private var currentTargetURL: URL?
    private var hostingView: NSHostingView<PopupView>?

    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 440, height: 55),
            styleMask: [.nonactivatingPanel, .fullSizeContentView, .borderless],
            backing: .buffered,
            defer: false
        )
        
        self.isFloatingPanel = true
        self.level = .statusBar
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = true
        self.isReleasedWhenClosed = false
        self.hidesOnDeactivate = false
    }

    func show(at url: URL) {
        self.currentTargetURL = url
        
        let view = PopupView(
            onSubmit: { [weak self] filename in self?.createFile(filename) },
            onCancel: { [weak self] in self?.closePanel() }
        )
        
        if hostingView == nil {
            let contentRect = NSRect(origin: .zero, size: self.frame.size)
            let effectView = NSVisualEffectView(frame: contentRect)
            
            // Explicit type naming for Hackintosh/Tahoe compiler stability
            effectView.material = NSVisualEffectView.Material.hudWindow
            effectView.state = NSVisualEffectView.State.active
            effectView.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
            effectView.wantsLayer = true
            effectView.layer?.cornerRadius = 20
            
            let host = NSHostingView(rootView: view)
            host.translatesAutoresizingMaskIntoConstraints = false
            effectView.addSubview(host)
            
            NSLayoutConstraint.activate([
                host.topAnchor.constraint(equalTo: effectView.topAnchor),
                host.bottomAnchor.constraint(equalTo: effectView.bottomAnchor),
                host.leadingAnchor.constraint(equalTo: effectView.leadingAnchor),
                host.trailingAnchor.constraint(equalTo: effectView.trailingAnchor)
            ])
            
            self.contentView = effectView
            self.hostingView = host
        } else {
            self.hostingView?.rootView = view
        }
        
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.center()
            
            NSApp.activate(ignoringOtherApps: true)
            
            self.makeKeyAndOrderFront(nil)
            self.orderFrontRegardless()
            if !self.isKeyWindow {
                self.makeKey()
            }
            
            print("PopupPanel: Force-show executed on macOS Tahoe.")
        }
    }

    private func createFile(_ filename: String) {
        guard let targetURL = currentTargetURL else { return }
        FileCreator.createFile(named: filename, at: targetURL)
        self.closePanel()
    }

    private func closePanel() {
        DispatchQueue.main.async {
            self.orderOut(nil)
            self.currentTargetURL = nil
        }
    }
    
    override func cancelOperation(_ sender: Any?) {
        closePanel()
    }
    
    // Explicitly allow becoming Key window for the TextField
    override var canBecomeKey: Bool { return true }
    override var canBecomeMain: Bool { return true }
}

struct PopupView: View {
    @State private var filename: String = ""
    var onSubmit: (String) -> Void
    var onCancel: () -> Void
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Main Content
            VStack {
                TextField("example.txt", text: $filename)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    .focused($isFocused)
                    .padding(.horizontal, 15)
                    .onSubmit {
                        if !filename.isEmpty {
                            onSubmit(filename)
                            filename = ""
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(0)
            
            // Close Button
            Button(action: {
                            onCancel()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable() // Allows precise sizing
                                .frame(width: 18, height: 18)
                                .foregroundColor(Color.secondary.opacity(0.8))
                                .offset(x: -10, y: 10)
                        }
            .buttonStyle(PlainButtonStyle())
            .zIndex(2)
            .onHover { isHovering in
                if isHovering {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isFocused = true
            }
        }
    }
}



