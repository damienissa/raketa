//
//  Injection.swift
//  RaketaTestTask
//
//  Created by Dima Virych on 22.10.2020.
//

import Foundation

public class Injection {
    
    public static  let global = Injection()
    
    private enum DependencyInjectionError: Error {
        case objectAlreadyRegistredInTheScope
        case objectNotRegistredInTheScope
    }
    
    public enum InsertionType<T: Any> {
        
        case interface(T.Type)
        case key(String)
        
        var key: String {
            switch self {
            case let .interface(value): return String(describing: value)
            case let .key(value): return value
            }
        }
    }
    
    private var container: [String: Any] = [:]
    
    public func register<T>(_ object: T, type: InsertionType<T> = .key(String(describing: T.self))) throws {
        
        if container[type.key] != nil {
            throw DependencyInjectionError.objectAlreadyRegistredInTheScope
        }
        
        container[type.key] = object
    }
    
    public func resolve<T>(_ type: InsertionType<T> = .key(String(describing: T.self))) throws -> T {
        
        guard let value = container[type.key] as? T else {
            throw DependencyInjectionError.objectNotRegistredInTheScope
        }
        
        return value
    }
}
