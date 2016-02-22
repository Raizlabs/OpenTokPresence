//
//  VideoOverlayButton.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/22/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

class VideoOverlayButton: UIButton {

    struct Constants {
        static let ButtonSize = CGFloat(50)
        static let ButtonAlpha = CGFloat(0.7)
        static let ButtonPressedAlpha = CGFloat(0.5)
        static let Inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    init(prefix: String) {
        super.init(frame: CGRectZero)
        setImage(UIImage(named: prefix.stringByAppendingString("-on")), forState: .Normal)
        setImage(UIImage(named: prefix.stringByAppendingString("-off")), forState: .Selected)
        backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(Constants.ButtonAlpha)
        contentEdgeInsets = Constants.Inset
        imageEdgeInsets = Constants.Inset
        layer.cornerRadius = Constants.ButtonSize / 2
        addTarget(self, action: "updateVideoOverlayPressedDownState", forControlEvents: [.TouchDown])
        addTarget(self, action: "updateVideoOverlayPressedUpState", forControlEvents: [.TouchUpInside])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateVideoOverlayPressedDownState() {
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(Constants.ButtonPressedAlpha)
    }

    func updateVideoOverlayPressedUpState() {
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(Constants.ButtonAlpha)
    }
    
}
