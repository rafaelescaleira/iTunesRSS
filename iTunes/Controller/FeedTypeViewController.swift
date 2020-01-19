//
//  FeedTypeViewController.swift
//  iTunes
//
//  Created by Rafael Escaleira on 08/12/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import UIKit

class FeedTypeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: UITableViewDelegate!
    var dataSource: UITableViewDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "feedType")
        self.tableView.delegate = self.delegate
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
    
    @IBAction func backButtonAction() {
        
        DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
    }
}
