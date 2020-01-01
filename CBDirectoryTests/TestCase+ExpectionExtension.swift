//
//  CBDirectoryTestCase.swift
//  CBDirectoryTests
//
//  Created by Rufus on 31/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    
    /// create an expectation witth a description. Defaultst to calling function name.
    /// In the logs this makes it easy to match failing expectations to tests
    /// - Parameter callingMethod: the description to use. This will default to the calling method if ommited
     func expectation(callingMethod: String = #function) -> XCTestExpectation {
        return self.expectation(description:"TestName:" + callingMethod)
    }
}
