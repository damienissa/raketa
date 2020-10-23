//
//  UITableView+Ext.swift
//
//  Created by Dima Virych on 11/22/18.
//  Copyright © 2018 Virych. All rights reserved.
//

import UIKit

extension UITableView {
    
    func cell<T>() -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }
    
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(UINib(nibName: String(describing: type), bundle: nil), forCellReuseIdentifier: String(describing: type))
    }
}
