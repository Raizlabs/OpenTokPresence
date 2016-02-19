//
//  SubscriberController.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/16/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

class SubscriberViewController: UIViewController {
    let session: OTSession
    var enabled = false
    var subscriber: OTSubscriber?
    var stream: OTStream?
    var error: OTError?

    var audioLevel: Float = 0

    init(session: OTSession) {
        self.session = session
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func subscribe(stream: OTStream) {
        self.stream = stream
        subscriber = OTSubscriber(stream: stream, delegate: self)
        subscriber?.viewScaleBehavior = .Fit
        session.subscribe(subscriber, error: &error)
    }

    func unsubscribe(stream: OTStream) {
        self.stream = nil
        session.unsubscribe(subscriber, error: &error)
    }

}

extension SubscriberViewController: OTSubscriberDelegate, OTSubscriberKitAudioLevelDelegate {

    func subscriberVideoDataReceived(subscriber: OTSubscriber!) {
    }

    func subscriberDidConnectToStream(subscriberKit: OTSubscriberKit) {
        if let subscriber = subscriber, let subscriberView = subscriber.view {
            subscriberView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subscriberView)
            subscriberView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
            subscriberView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
            subscriberView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
            subscriberView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        }
    }

    func subscriberVideoEnabled(subscriber: OTSubscriberKit!, reason: OTSubscriberVideoEventReason) {
        enabled = true
    }

    func subscriberVideoDisabled(subscriber: OTSubscriberKit!, reason: OTSubscriberVideoEventReason) {
        enabled = false
    }

    func subscriber(subscriber: OTSubscriberKit, didFailWithError error : OTError) {
        print("subscriber \(subscriber) didFailWithError \(error)")
        self.enabled = false
        self.error = error
    }

    func subscriber(subscriber: OTSubscriberKit!, audioLevelUpdated audioLevel: Float) {
        self.audioLevel = audioLevel
    }
}
