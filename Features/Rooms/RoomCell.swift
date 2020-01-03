//
//  RoomCell.swift
//  CBDirectory
//
//  Created by Rufus on 01/01/2020.
//  Copyright © 2020 Rufus. All rights reserved.
//

import Foundation
import UIKit

class RoomCell: UITableViewCell {
    static let cellID = "RoomCell"
    
    private let roomNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let activityStatusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    public var viewModel: RoomCellViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            self.roomNameLabel.text = vm.state.name
            self.activityStatusLabel.text = vm.state.availabilityStatusText
            self.activityStatusLabel.backgroundColor = vm.state.availabilityStatusColor
        }
    }
    
    var textStack: UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        textStack = UIStackView(arrangedSubviews: [roomNameLabel, activityStatusLabel])
        textStack.axis = .horizontal
        textStack.distribution = .fillProportionally
        
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(textStack)
        textStack.isLayoutMarginsRelativeArrangement = true
        
        let insets = CGFloat(16.0)
        textStack.layoutMargins = .init(top: insets, left: insets, bottom: insets, right: insets)
        textStack.constrainPinningEdgesToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
