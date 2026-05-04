//
//  ExtensionValidator.swift
//  NewFileMenu
//
//  Created by Juhen Ahmed on 2/5/26.
//


import Foundation

struct ExtensionValidator {
    static let supportedExtensions: Set<String> = [
        "html", "css", "txt", "js", "json", "md", "py", "sh", 
        "xml", "yaml", "yml", "swift", "java", "cpp", "c", 
        "ts", "jsx", "sql", "php"
    ]
    
    static func isValid(extension ext: String) -> Bool {
        return supportedExtensions.contains(ext)
    }
}


