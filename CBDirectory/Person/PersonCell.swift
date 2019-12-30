//
//  PersonCell.swift
//  CBDirectory
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation
import UIKit

class PersonCell: UITableViewCell {
    static let cellID = "PersonCell"
    private var viewModel: PersonCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: PersonCellViewModel) {
        self.viewModel = viewModel
        
        viewModel.stateChanged = { [weak self] state in
            guard let self = self else { return }
            
            self.textLabel?.text = state.firstName
            self.detailTextLabel?.text = state.lastName
            self.imageView?.image = state.avatar
        }
        
        viewModel.start()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.viewWillBeRecycled()
    }
}
