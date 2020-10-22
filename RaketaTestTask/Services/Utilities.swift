//
//  Utilities.swift
//  RaketaTestTask
//
//  Created by Dima Virych on 22.10.2020.
//

import Foundation

struct Utilities {
        
    struct Logger {
        
        static func log(_ message: Any, file: StaticString = #fileID, line: UInt = #line) {
            print("\nFile: \(file),\nLine: \(line),\nMessage: \(message)\n") // Can be replaced with analytics
        }
    }
}
