//
//  PersonCellViewModel.swift
//  CBDirectory
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation
import UIKit
import Common

public struct PersonCellViewState: CreateDefault {
    public typealias ViewState = PersonCellViewState
    
    public let id: String
    public var firstName: String
    public let lastName: String
    public let avatar: UIImage
    public let jobTitle: String
    
    public static func `default`() -> PersonCellViewState {
        return PersonCellViewState(id: "", firstName: "", lastName: "", avatar: PersonCellViewModel.placeholderImage, jobTitle: "")
    }
    
    func cloneStateReplacingImage(with image: UIImage) -> Self {
        return PersonCellViewState(id: id, firstName: firstName, lastName: lastName,
                                                 avatar: image, jobTitle: jobTitle)
    }
}

public class PersonCellViewModel: ViewModel<PersonCellViewState> {
    private var avatarURL: URL?
    private let person: Person
    var cellUpdateID: UUID?
    
    internal static let placeholderImage: UIImage = {
        let imgConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .thin)
        let image = UIImage(systemName: "person", withConfiguration: imgConfig)
        return image!
    }()
    
    public init(person: Person) {
        self.avatarURL = URL(string: person.avatar)
        self.person = person
        super.init()
        self.state = PersonCellViewState(id: person.id, firstName: person.firstName, lastName: person.lastName, avatar: PersonCellViewModel.placeholderImage, jobTitle: person.jobTitle)
    }

    /// begin loading cell
    /// - Parameter cellID: an ID that associates the view with the viewModel
    public func start(cellUpdateID: UUID) {
        self.cellUpdateID = cellUpdateID
        self.state = self.state.cloneStateReplacingImage(with: PersonCellViewModel.placeholderImage)
        
        let webClient = WebClient.shared
        
        if let avatarURL = avatarURL {
            webClient.get(url: avatarURL, completion: { (result) in
                DispatchQueue.main.sync {
                    switch result {
                    case .success(let data):
                        if let image = UIImage(data: data) {
                            self.state = self.state.cloneStateReplacingImage(with: image)
                        } else {
                            print("Couldnt create image")
                        }
                    case .failure(let error):
                        self.state = self.state.cloneStateReplacingImage(with: PersonCellViewModel.placeholderImage)
                        print(error.localizedDescription)
                    }
                }
            })
        }
    }
}
