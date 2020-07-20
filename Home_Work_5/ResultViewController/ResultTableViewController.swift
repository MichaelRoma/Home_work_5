//
//  ResultTableViewController.swift
//  Home_Work_5
//
//  Created by Mykhailo Romanovskyi on 01.07.2020.
//  Copyright © 2020 Mykhailo Romanovskyi. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {
    var model: JsonModel!
    let cell = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator()
    }
    
    private func configurator() {
        tableView.register(UINib.init(nibName: cell, bundle: nil), forCellReuseIdentifier: cell)
        tableView.rowHeight = CGFloat(100)
        tableView.sectionHeaderHeight = CGFloat(60)
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = "Repositories found: \(model.total_count)"
        return title
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .magenta
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellForSearchTable
        cell.cellConfigurator(with: model.items[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = URL(string: model.items[indexPath.row].html_url) else { return }
        let pushView = WebView()
        pushView.myUrl = url
        navigationController?.pushViewController(pushView, animated: true)
    }
}
