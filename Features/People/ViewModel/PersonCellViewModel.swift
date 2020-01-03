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
    public let firstName: String
    public let lastName: String
    public var avatar: UIImage? = nil
    public let jobTitle: String
    
    public static func `default`() -> PersonCellViewState {
        return PersonCellViewState(id: "", firstName: "", lastName: "", jobTitle: "")
    }
}

public class PersonCellViewModel: ViewModel<PersonCellViewState> {
    private var fetchAvatarTask: URLSessionTask? = nil
    private var avatarURL: URL?
    
    static let placeholderImage: UIImage = {
        let imgConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .thin)
        let image = UIImage(systemName: "person", withConfiguration: imgConfig)
        return image!
    }()
    
    public init(person: Person) {
        self.avatarURL = URL(string: person.avatar)
        super.init()
        self.state = PersonCellViewState(id: person.id, firstName: person.firstName, lastName: person.lastName,
                                         avatar: PersonCellViewModel.placeholderImage, jobTitle: person.jobTitle)
    }
    
    override public func start() {
        let webClient = WebClient.shared
        state.avatar = PersonCellViewModel.placeholderImage
        
        if let avatarURL = avatarURL {
            fetchAvatarTask = webClient.get(url: avatarURL, completion: { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        if let image = UIImage(data: data) {
                            self.state.avatar = image
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            })
        }
    }
    
    public func viewWillBeRecycled() {
        fetchAvatarTask?.cancel()
        state.avatar = PersonCellViewModel.placeholderImage
    }
}
