//
//  RedditTopListPresenter.swift
//  RaketaTestTask
//
//  Created Dima Virych on 21.10.2020.
//  Copyright © 2020 Dmytro Virych. All rights reserved.
//

import Foundation

public final class RedditTopListViewPresenter {
    
    // MARK: - Properties
    
    public weak var view: RedditTopListViewInterface?
    
    private var dataSource: RedditTopPagingDataSource
    
    init(dataSource: RedditTopPagingDataSource) {
        self.dataSource = dataSource
        self.dataSource.dataLoaded = { [weak self] in
            self?.view?.update(view: .loaded)
        }
    }
}


// MARK: - RedditTopListPresener

extension RedditTopListViewPresenter: RedditTopListPresener {
    
    public func numberOfRows() -> Int {
        dataSource.numberOfItems()
    }
    
    public func titleForRow(at index: Int) -> String {
        (try? dataSource.item(for: index))?.title ?? ""
    }
    
    public func descrForRow(at index: Int) -> String {
        guard let item = try? dataSource.item(for: index) else {
            return ""
        }
        
       return "Posted by " + item.author + " " + (item.date.timeAgoStringFromDate() ?? "")
    }
    
    public func igmURL(at index: Int) -> URL? {
        guard let item = try? dataSource.item(for: index), let str = item.img else {
            return nil
        }
        
        return URL(string: str)
    }
    
    
    public func loadData() {
        
        dataSource.loadMore()
    }
    
    public func isVideo(at index: Int) -> Bool {
        
        do {
            let item = try dataSource.item(for: index)
            return item.isVideo
        } catch {
            Utilities.Logger.log(error)
        }
        
        return false
    }
    
    public func videoURL(at index: Int) -> URL? {
        
        do {
            let item = try dataSource.item(for: index)
            if let str = item.videoURL, let url = URL(string: str) {
                return url
            }
        } catch {
            Utilities.Logger.log(error)
        }
        
        return nil
    }
}
