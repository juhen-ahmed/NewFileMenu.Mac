//
//  NewFileMenuApp.swift
//  NewFileMenu
//
//  Created by Juhen Ahmed on 2/5/26.
//

import SwiftUI

@main
struct NewFileMenuApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

