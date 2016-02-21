//
//  RemoteUser.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/18/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

struct RemoteUser {
    enum Status: String {
        case Online = "online"
        case Unavailable = "unavailable"

        var displayStatus: String {
            return self.rawValue.uppercaseStringWithLocale(nil)
        }
    }

    let name: String
    let identifier: String
    var status: Status
    var invitationSessionId: String?
    var invitationToken: String?
}