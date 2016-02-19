//
//  MultipleOverlayView.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

class HangoutView: UIView {
    
    struct Constants {
        static let padding = CGFloat(10)
        static let height = CGFloat(100)
    }

    var overlayViews: [UIView] = [] {
        didSet {
            let added = overlayViews.filter({$0.superview == nil})
            let removed = oldValue.filter({!overlayViews.contains($0)})

            added.forEach { addSubview($0) }
            removed.forEach { $0.removeFromSuperview() }

            if overlayViews.count > 0 {
                sendSubviewToBack(overlayViews[0])
            }

            setNeedsUpdateConstraints()
        }
    }

    var overlayConstraints = Array<NSLayoutConstraint>()

    override func setNeedsUpdateConstraints() {
        overlayConstraints.forEach() {
            $0.active = false
        }
        overlayConstraints.removeAll()
        super.setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        defer { super.updateConstraints() }
        guard overlayConstraints.count == 0  && overlayViews.count > 0 else {
            return
        }
        let primaryView = overlayViews[0]
        overlayConstraints.appendContentsOf([
            primaryView.topAnchor.constraintEqualToAnchor(self.topAnchor),
            primaryView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor),
            primaryView.leftAnchor.constraintEqualToAnchor(self.leftAnchor),
            primaryView.rightAnchor.constraintEqualToAnchor(self.rightAnchor),
            ])

        var previousAnchor = self.rightAnchor
        for view in overlayViews[1..<overlayViews.count] {
            overlayConstraints.appendContentsOf([
                view.heightAnchor.constraintEqualToConstant(Constants.height),
                self.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: Constants.padding),
                previousAnchor.constraintEqualToAnchor(view.rightAnchor, constant: Constants.padding),
                ])
            previousAnchor = view.leftAnchor
        }
        overlayConstraints.forEach { $0.active = true }
    }
    
}
