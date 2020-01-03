//
//  PersonDetailsViewModel.swift
//  CBDirectory
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation
import UIKit
import Common

public struct DataItemCellViewModel {
    public let title: String
    public let content: String
}

public struct PersonDetailsViewState: CreateDefault {
    public typealias ViewState = PersonDetailsViewState
    
    public static func `default`() -> ViewState {
        return PersonDetailsViewState(title: "Loading...", dataItems: [])
    }
    
    public var title: String
    public var errorMessage: String?
    public var avatar: UIImage?
    public var dataItems: [DataItemCellViewModel]
}

public class PersonDetailsViewModel: ViewModel<PersonDetailsViewState> {
    private var personService: PersonServiceProtocol
    private var selectedPersonID: String
    
    public init(personService: PersonServiceProtocol, personID: String, stateChanged: ((PersonDetailsViewState)->())? = nil) {
        self.personService = personService
        self.selectedPersonID = personID
        super.init(stateChanged: stateChanged)
    }
    
    public override func start() {
        super.start()
        self.personService.fetchPerson(id: selectedPersonID) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let personDetails):
                    let dataItems = [DataItemCellViewModel(title: "first name:", content: personDetails.firstName),
                                     DataItemCellViewModel(title: "last name:", content: personDetails.lastName),
                                     DataItemCellViewModel(title: "phone:", content: personDetails.phone),
                                     DataItemCellViewModel(title: "email:", content: personDetails.email),
                                     DataItemCellViewModel(title: "job title:", content: personDetails.jobTitle)]
                    
                    let title = "\(personDetails.firstName) \(personDetails.lastName)"
                    self.state = PersonDetailsViewState(title: title, errorMessage: self.state.errorMessage, avatar: self.state.avatar, dataItems: dataItems)
                    
                    if let avatarURL = URL(string: personDetails.avatar) {
                        WebClient.shared.get(url: avatarURL) { (result) in
                            switch result {
                            case .success (let imgData):
                                if let img = UIImage(data: imgData) {
                                    DispatchQueue.main.async { self.state.avatar = img }
                                } else {
                                    DispatchQueue.main.async { self.state.avatar = UIImage(systemName: "person") }
                                }
                            case .failure(let error):
                                print(error)
                                DispatchQueue.main.async { self.state.avatar = UIImage(systemName: "person") }
                            }
                        }
                    }
                    
                case .failure(let error):
                    let state = self.state
                    self.state = PersonDetailsViewState(title: "Load Failed", errorMessage: error.localizedDescription, avatar: state.avatar, dataItems: state.dataItems)
                }
            }
        }
    }
}
