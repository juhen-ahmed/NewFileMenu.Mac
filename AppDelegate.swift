//
//  AppDelegate.swift
//  NewFileMenu
//
//  Created by Juhen Ahmed on 2/5/26.
//



import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarManager: MenuBarManager?
    var popupPanel: PopupPanel?
    
    let appGroupID = "group.com.juhen.NewFileMenu"
    let notificationName = Notification.Name("com.juhen.NewFileMenu.ShowPopup")

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        LoginLaunchManager.registerApp()
        let _ = NotificationManager.shared
        NotificationManager.shared.requestPermission()
        
        menuBarManager = MenuBarManager()
        popupPanel = PopupPanel()
        
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(handleFinderSyncTrigger),
            name: notificationName,
            object: nil,
            suspensionBehavior: .deliverImmediately
        )
        
        print("Main App: Ready and listening...")
    }

    @objc func handleFinderSyncTrigger() {
        print("--- Trigger Received from Finder ---")
        
        guard let defaults = UserDefaults(suiteName: appGroupID) else {
            print("Error: App Group defaults not found.")
            return
        }
        
        defaults.synchronize()
        
        guard let pathString = defaults.string(forKey: "TargetFolderPath") else {
            print("Error: Target folder path missing from defaults.")
            return
        }
        
        let url = URL(fileURLWithPath: pathString)
        
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
            self.popupPanel?.show(at: url)
        }
    }
}
