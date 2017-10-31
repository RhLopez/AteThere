//
//  HomeViewController.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/29/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UITableViewController {
    
    var venueService: VenueServicing?
    var dataSource: HomeTableViewDataSource?
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let venues = venueService?.getVenues() {
            dataSource = HomeTableViewDataSource(withVenues: venues)
            tableView.dataSource = dataSource
        }
    }
    
    func subscribeNotificationToken() {
        notificationToken = establishments.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
}
