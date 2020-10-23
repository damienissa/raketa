//
//  RedditTopListView.swift
//  RaketaTestTask
//
//  Created Dima Virych on 21.10.2020.
//  Copyright © 2020 Dmytro Virych. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imgView: UIImageView!
}

public final class RedditTopListView: UIViewController {
    
    // MARK: - Instantiate
    
    static func instantiate() -> Self {
        
        UIStoryboard(name: String(describing: Self.self), bundle: nil).instantiateViewController(withIdentifier: String(describing: Self.self)) as! Self
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    public var presenter: RedditTopListPresener?
}


// MARK: - RedditTopListViewInterface

extension RedditTopListView: RedditTopListViewInterface {
    
    public func update(view state: RedditTopListViewState) {
        
        switch state {
        case .loaded:
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .empty: return
        case .loading: return
        }
    }
}


extension RedditTopListView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        (presenter?.numberOfRows() ?? 0) + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            presenter?.loadData()
            let cell = UITableViewCell()
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.center = cell.center
            cell.addSubview(indicator)
            indicator.startAnimating()
            return cell
        }
        
        let cell: ContentCell = tableView.cell()
        if let pres = presenter {
            cell.title.text = pres.titleForRow(at: indexPath.row)
            cell.descriptionLabel.text = pres.descrForRow(at: indexPath.row)
            if pres.isVideo(at: indexPath.row), let url = pres.videoURL(at: indexPath.row) {
                cell.imgView?.playVideo(url)
            } else {
                if let url = pres.igmURL(at: indexPath.row) {
                    cell.imgView.setImage(url)
                    cell.imgView.isHidden = false
                } else {
                    cell.imgView.isHidden = true
                }
            }
        }
        
        return cell
    }
}
