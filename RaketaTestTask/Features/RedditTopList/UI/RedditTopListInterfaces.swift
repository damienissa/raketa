//
//  RedditTopListInterfaces.swift
//  RaketaTestTask
//
//  Created Dima Virych on 21.10.2020.
//  Copyright © 2020 Dmytro Virych. All rights reserved.
//

import Foundation

public protocol RedditTopListViewInterface: class {
    
    var presenter: RedditTopListPresener? { get set }
    
    func update(view state: RedditTopListViewState)
}

public protocol RedditTopListPresener {
    
    var view: RedditTopListViewInterface? { get set }
    
    func loadData()
    
    func numberOfRows() -> Int
    func titleForRow(at index: Int) -> String
    func descrForRow(at index: Int) -> String
    func igmURL(at index: Int) -> URL?
    func isVideo(at index: Int) -> Bool
    func videoURL(at index: Int) -> URL?
}
