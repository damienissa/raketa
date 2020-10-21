//
//  FeedService.swift
//  RaketaTestTask
//
//  Created by Dima Virych on 21.10.2020.
//

import Foundation

public protocol FeedService {
    
    func loadFeed(for page: Int, completion: (Result<FeedService, Error>) -> Void)
}
