//
//  FinderSync.swift
//  NewFileMenu
//
//  Created by Juhen Ahmed on 2/5/26.
//



import Cocoa
import FinderSync

class FinderSync: FIFinderSync {
    let appGroupID = "group.com.juhen.NewFileMenu"
    let notificationName = "com.juhen.NewFileMenu.ShowPopup"

    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let menu = NSMenu(title: "")
        if menuKind == .contextualMenuForContainer || menuKind == .contextualMenuForItems {
            let menuItem = NSMenuItem(
                title: "New File",
                action: #selector(triggerNewFileAction(_:)),
                keyEquivalent: ""
            )
            menuItem.target = self
            if let icon = NSImage(systemSymbolName: "doc.badge.plus", accessibilityDescription: nil) {
            let config = NSImage.SymbolConfiguration(hierarchicalColor: .systemBlue)
            let coloredIcon = icon.withSymbolConfiguration(config)
                                                
            menuItem.image = coloredIcon
            }
            menu.addItem(menuItem)
        }
        return menu
    }

    @objc func triggerNewFileAction(_ sender: AnyObject?) {
        guard let targetURL = FIFinderSyncController.default().targetedURL() else { return }
        
        if let defaults = UserDefaults(suiteName: appGroupID) {
            // FIXED: Send the raw path string instead of a restricted bookmark
            defaults.set(targetURL.path, forKey: "TargetFolderPath")
            defaults.synchronize()
            
            DistributedNotificationCenter.default().postNotificationName(
                NSNotification.Name(notificationName),
                object: nil,
                userInfo: nil,
                deliverImmediately: true
            )
            print("Extension: Sent path -> \(targetURL.path)")
        }
    }
}
