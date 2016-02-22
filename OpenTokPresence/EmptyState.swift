//
//  EmptyState.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/18/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

enum EmptyStateStyle {
    case Spinner
    case Image(image: UIImage)
}

protocol EmptyState {
    var title: String? { get }
    var message: String? { get }
    var style: EmptyStateStyle { get }
}
