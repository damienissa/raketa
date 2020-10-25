//
//  RedditTopPagingDataSource.swift
//  RaketaTestTask
//
//  Created by Dima Virych on 21.10.2020.
//

import Foundation

public class RedditTopPagingDataSource {
    
    // MARK: - Constants
    
    private let itemsPerPage = 10
    
   
    // MARK: - Properties
    
    private var after: String = ""
    private var feedService: FeedService
    private var feedList: [FeedItem] = []
    
    
    // MARK: - Public Properties
    
    public var dataLoaded: ((Range<Int>, Bool) -> Void)?
    
    
    // MARK: - Lifecycle
    
    public init(_ feedService: FeedService) {
        
        self.feedService = feedService
    }
    
    
    // MARK: - Actions
    
    public func reload() {
        
        feedList = []
        after = ""
        loadMore()
    }
    
    public func loadMore() {
        
        feedService.loadFeed(after: after) { [weak self] (result) in
            
            switch result {
            case let .success(data):
                self?.feedList.append(contentsOf: data.list)
                let end = self?.feedList.count ?? 0
                self?.after = data.after
                self?.dataLoaded?(end - data.list.count ..< end, self?.after == "")
            case let .failure(error):
                Utilities.Logger.log(error)
            }
        }
    }
    
    public func numberOfItems() -> Int {
        
        feedList.count
    }
    
    public func item(for index: Int) throws -> FeedItem {
        
        if 0 ..< feedList.count ~= index {
            return feedList[index]
        }
        
        throw GlobalError.indexOutOfRange
    }
}
