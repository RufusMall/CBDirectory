//
//  PersonDetailsViewController.swift
//  CBDirectory
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation
import UIKit

class PersonDetailViewController: UIViewController {
    var personDetailsViewModel: PersonDetailsViewModel!
    
    public init(personVM: PersonCellViewModel, personService:PersonServiceProtocol) {
        super.init(nibName: nil, bundle: nil)
        
        personDetailsViewModel = PersonDetailsViewModel(personService: personService, personID: personVM.state.id) { (state) in
            self.title = state.title
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemRed
        
        personDetailsViewModel.start()
    }
}
