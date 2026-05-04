//
//  LoginLaunchManager.swift
//  NewFileMenu
//
//  Created by Juhen Ahmed on 2/5/26.
//


import Foundation
import ServiceManagement

struct LoginLaunchManager {
    static func registerApp() {
        // Requires macOS 13.0+
        if #available(macOS 13.0, *) {
            let service = SMAppService.mainApp
            do {
                if service.status != .enabled {
                    try service.register()
                }
            } catch {
                print("Failed to register app for login launch: \(error)")
            }
        }
    }
}

