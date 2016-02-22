//
//  SessionState.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/16/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

enum SessionState {
    case Connecting
    case Connected
    case Error(message: String)
    case Completed(message: String)
}

extension SessionState : EmptyState {

    var title: String? {
        get {
            switch self {
            case .Connecting:
                return "Connecting"
            case .Error(_):
                return "Error"
            case .Completed(_):
                return "Disconnected"
            default:
                return nil
            }
        }
    }

    var message: String? {
        get {
            switch self {
            case .Connecting:
                return ""
            case .Error(let message):
                return message
            case .Completed(let message):
                return message
            default:
                return nil
            }
        }
    }

    var style: EmptyStateStyle {
        get {
            return .Spinner
        }
    }

}