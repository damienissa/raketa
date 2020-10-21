//
//  RedditTopListPresenter.swift
//  RaketaTestTask
//
//  Created Dima Virych on 21.10.2020.
//  Copyright © 2020 Dmytro Virych. All rights reserved.
//

public final class RedditTopListViewPresenter {
    
    // MARK: - Properties
    
    public weak var view: RedditTopListViewInterface?
}


// MARK: - RedditTopListPresener

extension RedditTopListViewPresenter: RedditTopListPresener {
    
    public func loadData() {
        view?.update(view: .empty)
    }
}
