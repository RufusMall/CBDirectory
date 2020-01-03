//
//  ViewController.swift
//  CBDirectory
//
//  Created by Rufus on 22/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import UIKit

class PersonListViewController: UIViewController {
    var viewModel: PersonListViewModel!
    var personService: PersonServiceProtocol!
    
    init(personService: PersonServiceProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "People", systemName: "person")
        self.personService = personService
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
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
        tableView.rowHeight = UITableView.automaticDimension
        refreshControl.addTarget(self, action: #selector(self.refreshControlChanged), for: .valueChanged)
        
        viewModel = PersonListViewModel(service: personService, stateChanged: { [weak self] (state) in
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
            
            self.searchController.searchBar.placeholder = state.searchTextPlaceholder
            
            self.refreshControl.endRefreshing()
        })
        
        navigationItem.searchController = self.searchController
        
        self.searchController.searchResultsUpdater = self
        
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
        cell.viewModel = personVM
        return cell
    }
}

extension PersonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //move this out to somewhere else, coordinator?
        let personVM = viewModel.state.people[indexPath.row]
        let vc = PersonDetailsViewController(personID: personVM.state.id, personService: personService)
        self.splitViewController?.showDetailViewController(vc, sender: self)
    }
}

extension PersonListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchFilter = searchController.searchBar.text
    }
}

import SwiftUI
class PersonListPreview: DirectoryTabControllerPreview {
}

class PersonListControllerPreview: DirectoryTabControllerPreview, PreviewProvider {
}
