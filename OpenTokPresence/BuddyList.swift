//
//  BuddyList.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/18/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

struct BuddyList {
    var users: [RemoteUser]

    var invitations: [RemoteUser] {
        return users.filter() { $0.invitationSessionId != nil }
    }

    var hasInvitations: Bool { return invitations.count > 0 }

    private func lookupByIdentifier(identifier: String) -> Int? {
        return users.indexOf() { $0.identifier == identifier }
    }

    func tokenForInvitationSentTo(identifier: String) -> String? {
        guard let existingIndex = lookupByIdentifier(identifier) else {
            return nil
        }
        return users[existingIndex].invitationToken
    }

    mutating func connect(identifier: String, name: String) {
        let user = RemoteUser(name: name, identifier: identifier, status: .Online, invitationSessionId: nil, invitationToken: nil)
        if let existingIndex = lookupByIdentifier(identifier) {
            users[existingIndex] = user
        }
        else {
            users.append(user)
        }
    }

    mutating func disconnect(identifier: String) {
        if let existingIndex = lookupByIdentifier(identifier) {
            users.removeAtIndex(existingIndex)
        }
    }

    mutating func updateStatus(identifier: String, status: RemoteUser.Status) {
        guard let existingIndex = lookupByIdentifier(identifier) else { return }
        var user = users[existingIndex]
        user.status = status
        users[existingIndex] = user
    }

    mutating func receivedInvite(identifier: String, invitationSessionId: String) {
        guard let existingIndex = lookupByIdentifier(identifier) else { return }
        var user = users[existingIndex]
        user.invitationSessionId = invitationSessionId
        users[existingIndex] = user
    }

    mutating func sentInvite(identifier: String, invitationSessionId: String, invitationToken: String) {
        guard let existingIndex = lookupByIdentifier(identifier) else { return }
        var user = users[existingIndex]
        user.invitationSessionId = invitationSessionId
        user.invitationToken = invitationToken
        users[existingIndex] = user
    }

    mutating func clearInvite(identifier: String) {
        guard let existingIndex = lookupByIdentifier(identifier) else { return }
        var user = users[existingIndex]
        user.invitationSessionId = nil
        user.invitationToken = nil
        users[existingIndex] = user
    }

    mutating func cancelInvite(identifier: String) {
        guard let existingIndex = lookupByIdentifier(identifier) else { return }
        var user = users[existingIndex]
        user.invitationSessionId = nil
        user.invitationToken = nil
        users[existingIndex] = user
    }
}
