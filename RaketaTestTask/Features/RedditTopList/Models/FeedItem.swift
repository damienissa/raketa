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

    public init(total: Int, list: [FeedItem]) {
        
        self.total = total
        self.list = list
    }
}

public struct FeedItem {
    
    private let id = UUID()
    public let title: String
    public let author: String
    public let date: Date
    public let img: String?
    public let numberOfComents: Int
    public let isVideo: Bool
    public let videoURL: String?
}

extension FeedItem: Equatable {
    
    public static func == (_ l: Self, _ r: Self) -> Bool {
        l.id == r.id
    }
}


#if DEBUG
extension FeedItem {
    
    public static let demo = FeedItem(title: "Title", author: "Author", date: .init(), img: nil, numberOfComents: 300, isVideo: false, videoURL: nil)
}
#endif
