//
//  RedditTopListView.swift
//  RaketaTestTask
//
//  Created Dima Virych on 21.10.2020.
//  Copyright © 2020 Dmytro Virych. All rights reserved.
//

import UIKit

public final class RedditTopListView: UIViewController {
    
    // MARK: - Instantiate
    
    static func instantiate() -> Self {
        
        UIStoryboard(name: String(describing: Self.self), bundle: nil).instantiateViewController(withIdentifier: String(describing: Self.self)) as! Self
    }
    
    
    // MARK: - Properties
    
    public var presenter: RedditTopListPresener?
}


// MARK: - RedditTopListViewInterface

extension RedditTopListView: RedditTopListViewInterface {
    
    public func update(view state: RedditTopListViewState) {
        
        switch state {
        case let .loaded(data: data):
            print(data)
        case .empty: return
        case .loading: return
        }
    }
}
