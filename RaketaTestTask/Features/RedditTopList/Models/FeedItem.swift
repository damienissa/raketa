//
//  FeedItem.swift
//  RaketaTestTask
//
//  Created by Dima Virych on 21.10.2020.
//

import Foundation

public struct FeedResponse {
    
    public let total: Int
    public let list: [FeedItem]
    public let after: String
    public init(total: Int, list: [FeedItem], after: String) {
        
        self.total = total
        self.list = list
        self.after = after
    }
}

public struct FeedItem {
    
    private let id = UUID()
    public let title: String
    public let author: String
    public let date: Date
    public let img: String?
    public let numberOfComents: Int
}

extension FeedItem: Equatable {
    
    public static func == (_ l: Self, _ r: Self) -> Bool {
        l.id == r.id
    }
}
