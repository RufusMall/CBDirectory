//
//  DataDetectionCell.swift
//  CBDirectory
//
//  Created by Rufus on 31/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation
import UIKit

/// Cell that supports detection of data such as phone numbers, emails etc. See: UIDataDetectorTypes
class DataDetectorCell: UITableViewCell {
    static let cellID = "DataDetectorCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let dataDetectionTxtView: UITextView = {
        let txtView = UITextView()
        txtView.isEditable = false
        txtView.dataDetectorTypes = .all
        txtView.isScrollEnabled = false
        txtView.textContainerInset = .zero
        txtView.textContainer.lineFragmentPadding = 0
        return txtView
    }()
    
    public var dataItemViewModel: DataItemCellViewModel? {
        didSet {
            if let dataItem = dataItemViewModel {
                titleLabel.text = dataItem.title
                dataDetectionTxtView.text = dataItem.content
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        dataDetectionTxtView.font = titleLabel.font
        let containerStackView = UIStackView(arrangedSubviews: [titleLabel, dataDetectionTxtView])
        self.contentView.addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.constrainPinningEdgesToSuperview()
        containerStackView.layoutMargins = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)
        containerStackView.spacing = 6.0
        containerStackView.isLayoutMarginsRelativeArrangement = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
