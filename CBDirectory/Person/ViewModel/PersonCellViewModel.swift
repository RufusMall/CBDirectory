//
//  PersonCellViewModel.swift
//  CBDirectory
//
//  Created by Rufus on 30/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation
import UIKit

public class PersonCellViewModel {
    public struct State {
        public let id: String
        public let firstName: String
        public let lastName: String
        public var avatar: UIImage?
    }
    
    public var stateChanged: (State)->() = { _ in }
    private var fetchAvatarTask: URLSessionTask? = nil
    private var avatarURL: URL?
    
    public var state: State {
        didSet {
            self.stateChanged(self.state)
        }
    }
    
    static let placeholderImage: UIImage = {
        let imgConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .thin)
        let image = UIImage(systemName: "person", withConfiguration: imgConfig)
        return image!
    }()
    
    public init(person: Person) {
        self.state = State(id: person.id, firstName: person.firstName, lastName: person.lastName, avatar: nil)
        self.avatarURL = URL(string: person.avatar)
        stateChanged(state)
    }
    
    public func start() {
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
        if let currentFetch = fetchAvatarTask {
            currentFetch.cancel()
        }
        state.avatar = nil
    }
}
