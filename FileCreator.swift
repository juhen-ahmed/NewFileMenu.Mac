//
//  FileCreator.swift
//  NewFileMenu
//
//  Created by Juhen Ahmed on 2/5/26.
//



import Foundation

struct FileCreator {
    static func createFile(named filename: String, at url: URL) {
        let cleanName = filename.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let fileURL = url.appendingPathComponent(cleanName)
        let ext = fileURL.pathExtension.lowercased()
        
        if ext.isEmpty || !ExtensionValidator.isValid(extension: ext) {
            let errorMsg = ext.isEmpty ? "No extension found." : "'.\(ext)' is not supported."
            NotificationManager.shared.showNotification(title: "Type isn't valid", body: errorMsg)
            return
        }

        let fileManager = FileManager.default
        
        // Check if file exists
        if fileManager.fileExists(atPath: fileURL.path) {
            NotificationManager.shared.showNotification(title: "Error", body: "File '\(cleanName)' already exists.")
            return
        }
        
        let success = fileManager.createFile(atPath: fileURL.path, contents: Data(), attributes: nil)
        
        if success {
            print("FileCreator: Success -> \(fileURL.path)")
            NotificationManager.shared.showNotification(title: "Success", body: "Created \(cleanName)")
        } else {
            print("FileCreator: Failed at \(fileURL.path)")
            NotificationManager.shared.showNotification(title: "Failed", body: "Could not write to folder.")
        }
    }
}


