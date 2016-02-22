//
//  Message.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/18/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

enum Message {
    private static let StatusKey = "status"
    private static let InvitationKey = "invitation"
    private static let CancelInvitationKey = "cancelInvitation"
    private static let AcceptInvitationKey = "acceptInvitation"
    private static let DeclineInvitationKey = "declineInvitation"
    private static let Separator = "~"

    case Status(identifier: String, status: RemoteUser.Status)
    case Invitation(identifier: String, sessionInfo: SessionInfo)
    case CancelInvitation(identifier: String, sessionInfo: SessionInfo)
    case AcceptInvitation(identifier: String, sessionInfo: SessionInfo)
    case DeclineInvitation(identifier: String, sessionInfo: SessionInfo)

    static func fromSignal(signalString: String, withString string: String, fromConnectionId connectionId: String?) -> Message? {
        let signalParts = signalString.componentsSeparatedByString(Separator)
        let signalName = signalParts.last!

        // Status messages are the only message with out session info
        guard signalName != StatusKey else {
            return .Status(identifier:signalParts[0], status: RemoteUser.Status(rawValue: string)!)
        }
        guard let sessionInfo = SessionInfo.fromString(string) else {
            return nil
        }

        switch signalName {
        case InvitationKey:
            return .Invitation(identifier:connectionId!, sessionInfo: sessionInfo)
        case CancelInvitationKey:
            return .CancelInvitation(identifier:connectionId!, sessionInfo: sessionInfo)
        case AcceptInvitationKey:
            return .AcceptInvitation(identifier:connectionId!, sessionInfo: sessionInfo)
        case DeclineInvitationKey:
            return .DeclineInvitation(identifier:connectionId!, sessionInfo: sessionInfo)
        default:
            fatalError("Unknown type \(signalString)")
        }
    }


    func toSignal() -> (String, String) {
        switch self {
        case let .Status(identifier, status):
            let type = [Message.StatusKey, identifier].joinWithSeparator(Message.Separator)
            return (type, status.rawValue)
        case let .Invitation(_, sessionInfo):
            return (Message.InvitationKey, sessionInfo.toString())
        case let .CancelInvitation(_, sessionInfo):
            return (Message.CancelInvitationKey, sessionInfo.toString())
        case let .AcceptInvitation(_, sessionInfo):
            return (Message.AcceptInvitationKey, sessionInfo.toString())
        case let .DeclineInvitation(_, sessionInfo):
            return (Message.DeclineInvitationKey, sessionInfo.toString())
        }
    }
}