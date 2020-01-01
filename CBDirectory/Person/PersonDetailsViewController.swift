//
//  PersonDetailsViewController.swift
//  CBDirectory
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation
import UIKit

public class PersonDetailsViewController: UIViewController {
    var personDetailsViewModel: PersonDetailsViewModel!
    let avatarImageSize: CGFloat = 128.0
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        return tableView
    }()
    
    private var profileHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var avatarCircleImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .systemGray
        imgView.layer.masksToBounds = true
        imgView.layer.borderWidth = 2.0
        return imgView
    }()
    
    private func layoutAvatarImageView(animated:Bool) {
        let animationSpeed = animated ? 0.4 : 0.0
        UIView.animate(withDuration: animationSpeed) {
            self.avatarCircleImageView.layoutIfNeeded()
            self.avatarCircleImageView.layer.cornerRadius = self.avatarCircleImageView.frame.height / 2.0
        }
    }
    
    private func showFailedToLoadMessage(_ state: PersonDetailsViewModel.State) {
        if let errorMessage = state.errorMessage {
            let errorLabel = UILabel()
            errorLabel.text = errorMessage
            tableView.backgroundView = errorLabel
        } else {
            tableView.backgroundView = nil
        }
    }
    
    var imgWidthConstraint: NSLayoutConstraint!
    var imgHeightConstraint: NSLayoutConstraint!
    
    public init(personID: String, personService: PersonServiceProtocol) {
        super.init(nibName: nil, bundle: nil)
        
        personDetailsViewModel = PersonDetailsViewModel(personService: personService, personID: personID) { [weak self] (state) in
            guard let self = self else { return }
            
            self.title = state.title
            
            if let avatar = state.avatar {
                self.avatarCircleImageView.image = avatar
                self.imgWidthConstraint.constant = self.avatarImageSize
                self.imgHeightConstraint.constant = self.avatarImageSize
                self.layoutAvatarImageView(animated: !UIAccessibility.isReduceMotionEnabled)
            }
            
            if state.dataItems.count > 0 {
                self.tableView.reloadData()
            }
            
            self.showFailedToLoadMessage(state)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        let imgViewContainer = UIView()
        imgViewContainer.translatesAutoresizingMaskIntoConstraints = false
        imgViewContainer.addSubview(avatarCircleImageView)
        
        let expectedImageHeightPlusRoomForMargins: CGFloat = avatarImageSize + 16.0
        imgViewContainer.heightAnchor.constraint(equalToConstant: expectedImageHeightPlusRoomForMargins).isActive = true
        imgViewContainer.centerXAnchor.constraint(equalTo: avatarCircleImageView.centerXAnchor).isActive = true
        imgViewContainer.centerYAnchor.constraint(equalTo: avatarCircleImageView.centerYAnchor).isActive = true
        
        imgWidthConstraint = self.avatarCircleImageView.heightAnchor.constraint(equalToConstant: 0)
        imgWidthConstraint.isActive = true
        imgHeightConstraint =  self.avatarCircleImageView.widthAnchor.constraint(equalToConstant: 0)
        imgHeightConstraint.isActive = true
        
        self.tableView.dataSource = self
        tableView.constrainPinningEdgesToSuperview()
        tableView.tableHeaderView = imgViewContainer
        imgViewContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        tableView.register(DataDetectorCell.self, forCellReuseIdentifier: DataDetectorCell.cellID)
        
        personDetailsViewModel.start()
    }
}

extension PersonDetailsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DataDetectorCell.cellID, for: indexPath) as! DataDetectorCell
        let dataItemVM = personDetailsViewModel.state.dataItems[indexPath.row]
        cell.dataItemViewModel = dataItemVM
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personDetailsViewModel.state.dataItems.count
    }
}

import SwiftUI
class PersonDetailPreview: ViewControllerPreviewProvider<PersonDetailsViewController>, PreviewProvider {
    override class func makeController() -> UIViewController {
        let personDetailViewController = PersonDetailsViewController(personID: "2", personService: MockPersonService())
        return personDetailViewController
    }
}
