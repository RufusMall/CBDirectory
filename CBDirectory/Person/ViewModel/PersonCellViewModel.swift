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
        public let firstName: String
        public let lastName: String
        public var avatar: UIImage?
    }
    
    public var stateChanged: (State)->() = { _ in }
    var fetchAvatarTask: URLSessionTask? = nil
    var avatarURL: URL?
    
    var state: State {
        didSet {
            DispatchQueue.main.async {
                self.stateChanged(self.state)
            }
        }
    }
    
    static let placeholderImage: UIImage = {
        let imgConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .thin)
        let image = UIImage(systemName: "person", withConfiguration: imgConfig)
        return image!
    }()
    
    public init(person: Person) {
        self.state = State(firstName: person.firstName, lastName: person.lastName, avatar: nil)
        self.avatarURL = URL(string: person.avatar)
    }
    
    public func start() {
        let webClient = WebClient.shared
        state.avatar = PersonCellViewModel.placeholderImage
        
        if let avatarURL = avatarURL {
            fetchAvatarTask = webClient.get(url: avatarURL, completion: { (result) in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        self.state.avatar = image
                    }
                case .failure(let error):
                    print(error.localizedDescription)
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
