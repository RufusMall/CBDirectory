//
//  Searchable.swift
//  CBDirectory
//
//  Created by Rufus on 03/01/2020.
//  Copyright © 2020 Rufus. All rights reserved.
//

import Foundation

public protocol Searchable {
    var searchableItems: [String] { get }
}

public extension Array where Element: Searchable {
    
    func filter(searchFilter: String?) -> Array<Element> {
        
        guard let searchFilter = searchFilter else {
            return self
        }
        
        guard !searchFilter.isEmpty else { return self }
        
        func lowercaseContains(string: String) -> Bool {
            let lowerStr = string.lowercased()
            return lowerStr.contains(searchFilter.lowercased())
        }
        
        return self.filter { (element) -> Bool in
            element.searchableItems.filter(lowercaseContains).count > 0
        }
        
    }
}

