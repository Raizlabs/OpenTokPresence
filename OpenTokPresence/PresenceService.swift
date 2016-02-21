//
//  PresenceService.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/18/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import Alamofire


class PresenceService {
    let manager = Alamofire.Manager()
}

// MARK: - Shared Types

struct Error {
    static let Domain = "com.raizlabs.presence"
    enum Code: Int {
        case InvalidResponseContent = -7001
    }

    static func errorWithCode(code: Code) -> NSError {
        return NSError(domain: Domain, code: code.rawValue, userInfo: [:])
    }
}

// MARK: - Presence

extension PresenceService {

    typealias SessionCompletion = (Alamofire.Result<SessionInfo, NSError>) -> Void

    func fetchPresence(completion: SessionCompletion) {
        manager
            .request(PresenceKit.Presence)
            .responseJSON() {response in
                guard response.result.error == nil else {
                    completion(.Failure(response.result.error!))
                    return
                }
                guard
                    let json = response.result.value as? Dictionary<String, AnyObject>,
                    let apiKey = json[APIConstants.VideoSessionKeys.apiKey] as? String,
                    let sessionId = json[APIConstants.VideoSessionKeys.sessionId] as? String
                    else
                {
                    completion(.Failure(Error.errorWithCode(.InvalidResponseContent)))
                    return
                }
                completion(.Success(SessionInfo(sessionId: sessionId, apiKey: apiKey)))
        }
    }
}


// MARK: - Register User

extension PresenceService {

    typealias TokenCompletion = (Alamofire.Result<String, NSError>) -> Void

    func registerUser(name: String, completion: TokenCompletion) {
        manager
            .request(PresenceKit.Register(name: name))
            .responseJSON() {response in
                guard response.result.error == nil else {
                    completion(.Failure(response.result.error!))
                    return
                }
                guard
                    let json = response.result.value as? Dictionary<String, AnyObject>,
                    let token = json[APIConstants.VideoSessionKeys.token] as? String
                    else
                {
                    completion(.Failure(Error.errorWithCode(.InvalidResponseContent)))
                    return
                }
                completion(.Success(token))
        }
    }
}

// MARK: - Chat

extension PresenceService {

    struct ChatResponse {
        let token: String
        let sessionInfo: SessionInfo
    }

    typealias ChatCompletion = (Alamofire.Result<ChatResponse, NSError>) -> Void

    func initiateChat(user: RemoteUser, completion: ChatCompletion) {
        manager
            .request(PresenceKit.Chat)
            .responseJSON() {response in
                guard response.result.error == nil else {
                    completion(.Failure(response.result.error!))
                    return
                }
                guard
                    let json = response.result.value as? Dictionary<String, AnyObject>,
                    let apiKey = json[APIConstants.VideoSessionKeys.apiKey] as? String,
                    let sessionId = json[APIConstants.VideoSessionKeys.sessionId] as? String,
                    let token = json[APIConstants.VideoSessionKeys.token] as? String
                    else
                {
                    completion(.Failure(Error.errorWithCode(.InvalidResponseContent)))
                    return
                }
                completion(.Success(ChatResponse(token: token, sessionInfo: SessionInfo(sessionId: sessionId, apiKey: apiKey))))
        }
    }

    func joinChat(user: RemoteUser, completion: ChatCompletion) {
        manager
            .request(PresenceKit.JoinChat(sessionId: user.invitationSessionId!))
            .responseJSON() {response in
                guard response.result.error == nil else {
                    completion(.Failure(response.result.error!))
                    return
                }
                guard
                    let json = response.result.value as? Dictionary<String, AnyObject>,
                    let apiKey = json[APIConstants.VideoSessionKeys.apiKey] as? String,
                    let sessionId = json[APIConstants.VideoSessionKeys.sessionId] as? String,
                    let token = json[APIConstants.VideoSessionKeys.token] as? String
                    else
                {
                    completion(.Failure(Error.errorWithCode(.InvalidResponseContent)))
                    return
                }
                completion(.Success(ChatResponse(token: token, sessionInfo: SessionInfo(sessionId: sessionId, apiKey: apiKey))))
        }
    }

}