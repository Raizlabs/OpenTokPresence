//
//  VideoView.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/22/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

class VideoView: UIView {

    struct Constants {
        static let Spacing = CGFloat(20)
    }

    lazy private(set) var muteAudioButton: UIButton = {
        return VideoOverlayButton(prefix: "mic")
    }()

    lazy private(set) var muteVideoButton: UIButton = {
        return VideoOverlayButton(prefix: "camera")
    }()

    lazy private(set) var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = Constants.Spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .Horizontal
        stack.addArrangedSubview(self.muteAudioButton)
        stack.addArrangedSubview(self.muteVideoButton)
        self.addSubview(stack)
        return stack
    }()

    var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let contentView = contentView {
                contentView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(contentView)
                sendSubviewToBack(contentView)
            }
            muteAudioButton.hidden = (contentView == nil)
            muteVideoButton.hidden = (contentView == nil)
            setNeedsUpdateConstraints()
        }
    }

    private var layoutConstraints : [NSLayoutConstraint] = []

    override func updateConstraints() {
        defer { super.updateConstraints() }
        layoutConstraints.removeAll()
        layoutConstraints.appendContentsOf([
            buttonStack.topAnchor.constraintEqualToAnchor(topAnchor, constant:Constants.Spacing),
            buttonStack.rightAnchor.constraintEqualToAnchor(rightAnchor, constant:-Constants.Spacing)
        ])
        if let contentView = contentView {
            layoutConstraints.appendContentsOf([
                contentView.topAnchor.constraintEqualToAnchor(topAnchor),
                contentView.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
                contentView.leftAnchor.constraintEqualToAnchor(leftAnchor),
                contentView.rightAnchor.constraintEqualToAnchor(rightAnchor)
                ])
        }
        NSLayoutConstraint.activateConstraints(layoutConstraints)
    }
}