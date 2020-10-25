//
//  RedditTopListView.swift
//  RaketaTestTask
//
//  Created Dima Virych on 21.10.2020.
//  Copyright © 2020 Dmytro Virych. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    
}
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
    
    private lazy var refreshController: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addSubview(refreshController)
    }
    
    @objc private func refresh() {
        
        presenter?.reloadData()
    }
}


// MARK: - RedditTopListViewInterface

extension RedditTopListView: RedditTopListViewInterface {
    
    public func update(view state: RedditTopListViewState) {
        
        switch state {
        case let .loaded(range):
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: range.map { IndexPath(row: $0, section: 0) }, with: .fade)
                self.tableView.endUpdates()
            }
        case .empty: return
        case .reloaded:
            DispatchQueue.main.async {
                self.refreshController.endRefreshing()
                self.tableView.reloadData()
            }
        case .loading: return
        }
    }
}


extension RedditTopListView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        (presenter?.numberOfRows() ?? 0) + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            presenter?.loadData()
            let cell: LoadingCell = tableView.cell()
            return cell
        }
        
        let cell: ContentCell = tableView.cell()
        if let pres = presenter {
            cell.title.text = pres.titleForRow(at: indexPath.row)
            cell.descriptionLabel.text = pres.descrForRow(at: indexPath.row)
            cell.imgView.image = nil
            if let url = pres.igmURL(at: indexPath.row) {
                cell.imgView.setImage(url)
            } else {
                cell.imgView.image = #imageLiteral(resourceName: "noimage")
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = presenter?.igmURL(at: indexPath.row) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
