//
//  App.swift
//  RaketaTestTask
//
//  Created by Dima Virych on 22.10.2020.
//

import Foundation

struct App {
    
    static func configure() {
        
        do {
            try Injection.global.register(RedditTopFeedService(), type: .interface(FeedService.self))
        } catch {
            Utilities.Logger.log(error)
        }
    }
}
