//
//  MultipleOverlayViewController.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

class HangoutViewController: UIViewController {
    var focusedViewController: UIViewController?

    var hangoutView = HangoutView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var participantViewControllers: [UIViewController] = [] {
        didSet {
            let added = participantViewControllers.filter({$0.parentViewController == nil})
            let removed = oldValue.filter({!participantViewControllers.contains($0)})

            added.forEach(addChildViewController)
            removed.forEach { $0.willMoveToParentViewController(nil) }

            if isViewLoaded() {
                updateHangoutViews()
            }

            added.forEach { $0.didMoveToParentViewController(self) }
            removed.forEach { $0.removeFromParentViewController() }
        }
    }

    private func updateHangoutViews() {
        hangoutView.overlayViews = participantViewControllers.map {
            $0.view.translatesAutoresizingMaskIntoConstraints = false
            return $0.view
        }
        hangoutView.layoutIfNeeded()
    }

    override func loadView() {
        view = hangoutView
        hangoutView.translatesAutoresizingMaskIntoConstraints = false
        updateHangoutViews()
        view.userInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTapView:"))
    }

    func didTapView(tgr: UITapGestureRecognizer) {
        let location = tgr.locationInView(self.view)
        var view = self.view.hitTest(location, withEvent: nil)
        while view != nil && hangoutView.overlayViews.contains(view!) == false {
            view = view?.superview
        }
        if let view = view,  let index = hangoutView.overlayViews.indexOf(view) {
            let vc = participantViewControllers[index]
            var viewControllers = participantViewControllers
            viewControllers.removeAtIndex(index)
            viewControllers.insert(vc, atIndex: 0)
            UIView.animateWithDuration(0.2) {
                self.participantViewControllers = viewControllers
            }
        }
    }

}