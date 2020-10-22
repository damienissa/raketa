//
//  RedditTopPagingDataSourceTestCase.swift
//  RaketaTestTaskTests
//
//  Created by Dima Virych on 21.10.2020.
//

import XCTest
import RaketaTestTask

class RedditTopPagingDataSourceTestCase: XCTestCase {
    
    func test_load_first_page() {
        
        let (sut, spy) = makeSUT()
        let expectation = self.expectation(description: "test_load_first_page")
        sut.dataLoaded = {
            expectation.fulfill()
        }
        sut.loadMore()
        spy.fill(.success((0..<10).map { _ in FeedItem.demo }))
        wait(for: [expectation], timeout: 0.3)
        
        XCTAssertEqual(sut.numberOfItems(), 10)
    }

    private func makeSUT() -> (RedditTopPagingDataSource, SPY) {
        
        let spy = SPY()
        let sut = RedditTopPagingDataSource(spy)
        
        return (sut, spy)
    }
    
    class SPY: FeedService {
        
        
        var page = 0
        
        var completion: ((Result<[FeedItem], Error>) -> Void)?
        
        func loadFeed(for page: Int, itemsPrePage count: Int, completion: @escaping (Result<[FeedItem], Error>) -> Void) {
            
            self.completion = completion
        }
        
        func fill(_ result: Result<[FeedItem], Error>) {
            completion?(result)
        }
    }
}
