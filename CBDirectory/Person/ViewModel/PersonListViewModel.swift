//
//  PersonViewModel.swift
//  CBDirectory
//
//  Created by Rufus on 24/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation
import UIKit

class PersonCellViewModel {
    struct State {
        let firstName: String
        let lastName: String
        var avatar: UIImage?
    }
    
    var stateChanged: (State)->() = { _ in }
    
    var state: State {
        didSet {
            DispatchQueue.main.async {
                self.stateChanged(self.state)
            }
        }
    }
    
    var fetchAvatarTask: URLSessionTask? = nil
    var avatarURL: URL?
    
    static let placeholderImage: UIImage = {
//        let imgConfig = UIImage.SymbolConfiguration(pointSize: 42, weight: .thin)
//        let image = UIImage(systemName: "person", withConfiguration: imgConfig)
        let image = UIImage(named: "person")
        return image!
    }()
    
    init(state: State, avatarURL: URL?) {
        self.state = state
        self.avatarURL = avatarURL
    }
    
    func Start() {
        let webClient = WebClient(session: URLSession.shared)
        state.avatar = PersonCellViewModel.placeholderImage
//        print(activity.destination)
        
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
    
    func viewWillBeRecycled() {
        if let currentFetch = fetchAvatarTask {
            currentFetch.cancel()
        }
        state.avatar = nil
    }
}

public class PersonListViewModel {
    public struct State {
        let title = "People"
        var errorName: String?
        var people = [PersonCellViewModel]()
    }
    
    let service: PersonServiceProtocol
    let stateChanged: (State)->()
    
    var state = State() {
        didSet {
            self.stateChanged(state)
        }
    }
    
    init(service:PersonServiceProtocol, stateChanged:@escaping (State)->()) {
        self.stateChanged = stateChanged
        self.service = service
    }
    
    func start() {
        self.stateChanged(state)
        fetchPeople()
    }
    
    private func fetchPeople() {
        service.fetchPeople { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let people):
                    let personViewModels = people.map { (person) -> PersonCellViewModel in
                        return PersonCellViewModel(state: .init(firstName: person.firstName, lastName: person.lastName, avatar: nil), avatarURL: URL(string: person.avatar))
                    }
                    self.state = State(errorName: nil, people: personViewModels)
                case .failure(let error):
                    self.state = State(errorName: error.localizedDescription, people: self.state.people)
                    print(error.localizedDescription)
                }
            }
        }
    }
}
