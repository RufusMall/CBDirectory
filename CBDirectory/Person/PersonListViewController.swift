//
//  ViewController.swift
//  CBDirectory
//
//  Created by Rufus on 22/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import UIKit

class PersonListViewController: UIViewController {
    var viewModel: PersonListViewModel! = nil
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "people", systemName: "person")
        
        let env = Environment.dev.url
        viewModel = PersonListViewModel(service: PersonService(baseURL: env), stateChanged: { [weak self] (state) in
            guard let self = self else { return }
            
            self.tabBarItem = UITabBarItem(title: state.title, systemName: "person")
            self.tableView.reloadData()
            self.title = state.title
            
            if let errorMsg = state.errorMessage {
                self.errorLabel.text = errorMsg
                self.tableView.backgroundView = self.errorLabel
            } else {
                self.tableView.backgroundView = nil
            }
            
            self.refreshControl.endRefreshing()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsMultipleSelection = false
        tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.cellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let viewToHideCellSeperatorsWhenTableIsEmpty = UIView()
        tableView.tableFooterView = viewToHideCellSeperatorsWhenTableIsEmpty
        return tableView
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.constrainPinningEdgesToSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshControlChanged), for: .valueChanged)
        viewModel.start()
    }
    
    @objc
    func refreshControlChanged(sender: Any?) {
        viewModel.refresh()
    }
}

extension PersonListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let personVM = viewModel.state.people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.cellID, for: indexPath) as! PersonCell
        cell.configure(viewModel: personVM)
        return cell
    }
}

extension PersonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBlue
        self.splitViewController?.showDetailViewController(vc, sender: self)
    }
}

import SwiftUI
class PersonListPreview: DirectoryTabControllerPreview, PreviewProvider {
}
