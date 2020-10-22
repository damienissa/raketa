//
//  FeedItem.swift
//  RaketaTestTask
//
//  Created by Dima Virych on 21.10.2020.
//

import Foundation

public struct FeedItem {
    
    private let id = UUID()
}

extension FeedItem: Equatable {
    
    public static func == (_ l: Self, _ r: Self) -> Bool {
        l.id == r.id
    }
}


#if DEBUG
extension FeedItem {
    
    public static let demo = FeedItem()
}
#endif
