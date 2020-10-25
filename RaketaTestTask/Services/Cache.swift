//
//  Cache.swift
//  RaketaTestTask
//
//  Created by Dima Virych on 24.10.2020.
//

import Foundation
import UIKit

class Cache {
    
    private var defaults = UserDefaults.standard
    private var key: String {
        "\(String(describing: UIImage.self))Cache"
    }
    private var names: [String] {
        get {
            defaults.array(forKey: key) as? [String] ?? []
        }
        set {
            defaults.setValue(newValue, forKey: key)
        }
    }
    
    
    func add(_ value: UIImage, with name: String) throws {
       
        if names.contains(name) {
            return
        }
        
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            throw NSError(domain: "Some error", code: -1, userInfo: nil)
        }
        
        guard let data = value.pngData() else {
            throw NSError(domain: "Some error", code: -1, userInfo: nil)
        }
        
        let url = URL(fileURLWithPath: path, isDirectory: true)
        
        try data.write(to: url.appendingPathComponent(name))
        names.append(name)
    }
    
    func getImage(name: String) -> UIImage? {
        
        if !names.contains(name) {
            return nil
        }
        
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        let url = URL(fileURLWithPath: path, isDirectory: true).appendingPathComponent(name)
        
        return UIImage(contentsOfFile: url.path)
    }
}
