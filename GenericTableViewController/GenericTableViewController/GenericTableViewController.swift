//
//  GenericTableViewController.swift
//  GenericTableViewController
//
//  Created by Luciano Pezzin on 10/12/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit

class BaseTableViewController<T: BaseCell<U>, U>:UITableViewController {

    let cellId = "id"
    
    var items = [U]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(T.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = rc
    }
    @objc func handleRefresh() {
        tableView.refreshControl?.endRefreshing()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BaseCell<U>
        cell.item = items[indexPath.row]
        return cell
    }

}

// Generec Base Cell
class BaseCell<U>: UITableViewCell {
    var item: U!
}
