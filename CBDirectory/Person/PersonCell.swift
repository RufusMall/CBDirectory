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
    
    private let avatarImageView: UIImageView = {
        let imgView = UIImageView()
        let size: CGFloat = 40
        imgView.widthAnchor.constraint(equalToConstant: size).isActive = true
        imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor).isActive = true
        imgView.layer.cornerRadius = size / 2.0
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public var viewModel: PersonCellViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            
            vm.stateChanged = { [weak self] state in
                guard let self = self else { return }
                
                self.titleLabel.text = state.firstName
                self.subtitleLabel.text = state.lastName
                self.avatarImageView.image = state.avatar
            }
            
            vm.start()
        }
    }
    
    var textStack: UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.distribution = .fillProportionally
        
        textStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textStack)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(avatarImageView)
        
        avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        avatarImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.0).isActive = true
        
        textStack.leadingAnchor.constraint(equalToSystemSpacingAfter: avatarImageView.trailingAnchor, multiplier: 1.0).isActive = true
        
        contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: textStack.trailingAnchor, multiplier: 1.0).isActive = true
        
        textStack.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1.0).isActive = true
        
        contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: textStack.bottomAnchor, multiplier: 1.0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.viewWillBeRecycled()
    }
}

import SwiftUI

class PersonCellPreviewer: PersonListPreview, PreviewProvider {
    
}
