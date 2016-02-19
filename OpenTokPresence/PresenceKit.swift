//
//  Endpoint.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/16/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import Alamofire

enum PresenceKit {
    case Presence
    case Register(name: String)
    case Chat
    case JoinChat(sessionId: String)
}


extension PresenceKit: APIEndpoint {
    var baseURLString: String {
        return "https://rz-presencekit-relayed.herokuapp.com/"
        // "https://rz-presencekit-routed.herokuapp.com/"
    }

    var encoding: Alamofire.ParameterEncoding {
        return .JSON
    }

    var method: Alamofire.Method {
        switch self {
        case .JoinChat(_): fallthrough
        case .Presence:
            return .GET
        case .Chat: fallthrough
        case .Register(_):
            return .POST
        }
    }

    var path: String {
        switch self {
        case .Presence:
            return "presence"
        case .Register(_):
            return "users"
        case .Chat:
            return "chats"
        case .JoinChat(let sessionId):
            return "chats?sessionId=\(sessionId)"
        }
    }

    var parameters: [String : AnyObject]? {
        switch self {
        case .Register(let name):
            return ["name": name]
        default:
            return nil
        }
    }

}

