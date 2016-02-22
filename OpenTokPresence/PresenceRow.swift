//
//  PresenceRow.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/18/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

enum PresenceRow {
    case Empty(emptyDescription: String)
    case User(remoteUser: RemoteUser)
    case Invite(remoteUser: RemoteUser, initiated: Bool)
}

extension BuddyList {

    func numberOfSections() -> Int {
        return hasInvitations ? 2 : 1
    }

    func numberOfRowsInSection(section: Int) -> Int {
        if hasInvitations && section == 0 {
            return invitations.count
        }
        else {
            return max(users.count, 1)
        }
    }

    func headerForSection(section: Int) -> String? {
        if (hasInvitations && section == 0) || users.count == 0 {
            return nil
        }
        else {
            return "Buddies"
        }
    }

    func rowAtIndexPath(indexPath: NSIndexPath) -> PresenceRow {
        if users.count == 0 {
            return .Empty(emptyDescription: "No Buddies")
        }
        if hasInvitations && indexPath.section == 0 {
            let user = invitations[indexPath.row]
            return .Invite(remoteUser: user, initiated: user.invitationToken != nil)
        }
        else {
            let user = users[indexPath.row]
            return .User(remoteUser: user)
        }
    }
}

class EmptyTableViewCell: UITableViewCell, AutomaticDequeue {
}

class InviteTableViewCell: UITableViewCell, AutomaticDequeue {
}

class UserTableViewCell: UITableViewCell, AutomaticDequeue {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

