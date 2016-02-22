//
//  SessionAccess.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

struct SessionInfo {
    let sessionId: String
    let apiKey: String

    static func fromString(string: String) -> SessionInfo? {
        guard let JSON: Dictionary<String, String> = string.toJSON() else {
            return nil
        }
        return SessionInfo.fromJSON(JSON)
    }

    static func fromJSON(JSON: Dictionary<String, String>) -> SessionInfo? {
        guard
            let sessionId = JSON[APIConstants.SessionKeys.sessionId],
            let apiKey = JSON[APIConstants.SessionKeys.apiKey] else {
                return nil
        }
        return SessionInfo(sessionId: sessionId, apiKey: apiKey)
    }


    func toString() -> String {
        return [
            APIConstants.SessionKeys.sessionId: sessionId,
            APIConstants.SessionKeys.apiKey: apiKey
            ].toJSONString()!
    }
}