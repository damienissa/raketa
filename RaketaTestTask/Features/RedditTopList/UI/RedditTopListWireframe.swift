//
//  RedditTopListWireframe.swift
//  RaketaTestTask
//
//  Created Dima Virych on 21.10.2020.
//  Copyright © 2020 Dmytro Virych. All rights reserved.
//

class RedditTopListWireframe {
    
    // MARK: - Properties
    
    var view: RedditTopListViewInterface?
    
    
    // MARK: - Lifecycle
    
    init() {
        
        view = RedditTopListView.instantiate()
        let presenter = RedditTopListViewPresenter()
        view?.presenter = presenter
        presenter.view = view
    }
}


// MARK: - Helper

import UIKit

extension UINavigationController {
    
    convenience init?(_ wireframe: RedditTopListWireframe) {
        guard let vc = wireframe.view as? UIViewController else {
            return nil
        }
        self.init(rootViewController: vc)
    }
    
    func push(_ wireframe: RedditTopListWireframe, animated: Bool = true) {
        
        guard let vc = wireframe.view as? UIViewController else {
            return
        }
        
        pushViewController(vc, animated: animated)
    }
}
