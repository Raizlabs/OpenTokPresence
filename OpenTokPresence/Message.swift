//
//  Message.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/18/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

enum Message {
    private static let statusKey = "status"
    private static let invitationKey = "invitation"
    private static let cancelInvitationKey = "cancelInvitation"
    private static let separator = "~"

    case Status(identifier: String, status: RemoteUser.Status)
    case Invitation(identifier: String, sessionId: String, apiKey: String)
    case CancelInvitation(identifier: String, sessionId: String, apiKey: String)

    static func fromSignal(signalString: String, withString string: String, fromConnectionId connectionId: String?) -> Message? {
        let signalParts = signalString.componentsSeparatedByString(separator)

        switch signalParts.last! {
        case statusKey:
            return .Status(identifier:signalParts[0], status: RemoteUser.Status(rawValue: string)!)
        case invitationKey:
            guard
                let data = string.dataUsingEncoding(NSUTF8StringEncoding),
                let JSONObject = try? NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments]),
                let JSON = JSONObject as? Dictionary<String, String>,
                let sessionId = JSON[APIConstants.SessionKeys.sessionId],
                let apiKey = JSON[APIConstants.SessionKeys.apiKey] else {
                    return nil
            }

            return .Invitation(identifier:connectionId!, sessionId:sessionId, apiKey: apiKey)
        case cancelInvitationKey:
            guard
                let data = string.dataUsingEncoding(NSUTF8StringEncoding),
                let JSONObject = try? NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments]),
                let JSON = JSONObject as? Dictionary<String, String>,
                let sessionId = JSON[APIConstants.SessionKeys.sessionId],
                let apiKey = JSON[APIConstants.SessionKeys.apiKey] else {
                    return nil
            }

            return .CancelInvitation(identifier:connectionId!, sessionId:sessionId, apiKey: apiKey)
        default:
            return nil
        }
    }

    static func jsonString(sessionId: String, apiKey: String) -> String {
        let object = [
            APIConstants.SessionKeys.sessionId: sessionId,
            APIConstants.SessionKeys.apiKey: apiKey
        ]
        let data = try! NSJSONSerialization.dataWithJSONObject(object, options:[])
        return String(data:data, encoding: NSUTF8StringEncoding)!
    }

    func toSignal() -> (String, String) {
        switch self {
        case let .Status(identifier, status):
            let type = [Message.statusKey, identifier].joinWithSeparator(Message.separator)
            return (type, status.rawValue)
        case let .Invitation(_, sessionId, apiKey):
            return (Message.invitationKey, Message.jsonString(sessionId, apiKey: apiKey))
        case let .CancelInvitation(_, sessionId, apiKey):
            return (Message.cancelInvitationKey, Message.jsonString(sessionId, apiKey: apiKey))
        }
    }
}