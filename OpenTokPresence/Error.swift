//
//  Error.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/21/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

struct Error {
    static let Domain = "com.raizlabs.presence"
    enum Code: Int {
        case InvalidResponseContent = -7001
    }

    static func errorWithCode(code: Code) -> NSError {
        return NSError(domain: Domain, code: code.rawValue, userInfo: [:])
    }
}
