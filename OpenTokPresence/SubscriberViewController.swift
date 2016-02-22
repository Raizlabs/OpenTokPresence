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
    var subscriber: OTSubscriber?
    var error: OTError? {
        didSet {
            if let error = error {
                fatalError("Unsupported Error \(error)")
            }
        }
    }

    var audioLevel: Float = 0

    lazy var videoView: VideoView = {
        let view = VideoView()
        return view
    }()

    init(session: OTSession) {
        self.session = session
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = videoView
        videoView.muteAudioButton.addTarget(self, action: "muteAudioPressed:", forControlEvents: [.TouchUpInside])
        videoView.muteVideoButton.addTarget(self, action: "muteVideoPressed:", forControlEvents: [.TouchUpInside])
    }

    func muteAudioPressed(sender: UIButton) {
        guard let subscriber = subscriber else {return}
        sender.selected = !sender.selected
        subscriber.subscribeToAudio = !subscriber.subscribeToAudio
    }

    func muteVideoPressed(sender: UIButton) {
        guard let subscriber = subscriber else {return}
        sender.selected = !sender.selected
        subscriber.subscribeToVideo = !subscriber.subscribeToVideo
    }

    func subscribe(stream: OTStream) {
        subscriber = OTSubscriber(stream: stream, delegate: self)
        subscriber?.viewScaleBehavior = .Fit
        session.subscribe(subscriber, error: &error)
    }

    func unsubscribe(stream: OTStream) {
        session.unsubscribe(subscriber, error: &error)
    }

}

extension SubscriberViewController: HangoutViewControllerLifecycle {

    func willChangeHangoutPosition(position: HangoutPosition) {
        videoView.buttonStack.hidden = (position == .Participant)
    }

}

extension SubscriberViewController: OTSubscriberDelegate, OTSubscriberKitAudioLevelDelegate {

    func subscriberVideoDataReceived(subscriber: OTSubscriber!) {
    }

    func subscriberDidConnectToStream(subscriberKit: OTSubscriberKit) {
        if let subscriber = subscriber, let subscriberView = subscriber.view {
            videoView.contentView = subscriberView
        }
    }

    func subscriberVideoEnabled(subscriber: OTSubscriberKit!, reason: OTSubscriberVideoEventReason) {
    }

    func subscriberVideoDisabled(subscriber: OTSubscriberKit!, reason: OTSubscriberVideoEventReason) {
    }

    func subscriber(subscriber: OTSubscriberKit, didFailWithError error : OTError) {
        print("subscriber \(subscriber) didFailWithError \(error)")
        self.error = error
    }

    func subscriber(subscriber: OTSubscriberKit!, audioLevelUpdated audioLevel: Float) {
        self.audioLevel = audioLevel
    }
}
