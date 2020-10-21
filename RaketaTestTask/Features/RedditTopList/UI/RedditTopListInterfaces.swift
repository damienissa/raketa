//
//  RedditTopListInterfaces.swift
//  RaketaTestTask
//
//  Created Dima Virych on 21.10.2020.
//  Copyright © 2020 Dmytro Virych. All rights reserved.
//

public protocol RedditTopListViewInterface: class {
    
    var presenter: RedditTopListPresener? { get set }
    
    func update(view state: RedditTopListViewState)
}

public protocol RedditTopListPresener {
    
    var view: RedditTopListViewInterface? { get set }
    
    func loadData()
}
