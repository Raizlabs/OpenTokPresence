//
//  PublisherController.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/16/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

class PublisherViewController: UIViewController {

    let session: OTSession
    var publisher: OTPublisher?
    var error: OTError?
    var cameraResolution = OTCameraCaptureResolution.High
    var cameraFrameRate: OTCameraCaptureFrameRate = .Rate30FPS

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
        guard let publisher = publisher else {return}
        sender.selected = !sender.selected
        publisher.publishAudio = !publisher.publishAudio
    }

    func muteVideoPressed(sender: UIButton) {
        guard let publisher = publisher else {return}
        sender.selected = !sender.selected
        publisher.publishVideo = !publisher.publishVideo
    }

    func publish() {
        assert(publisher == nil)
        publisher = OTPublisher(delegate: self, name: "Test", cameraResolution: cameraResolution, cameraFrameRate: cameraFrameRate)
        if let publisher = publisher {
            session.publish(publisher, error: &error)
        }
    }

    func unpublish() {
        session.unpublish(publisher, error: &error)
    }
}

extension PublisherViewController: HangoutViewControllerLifecycle {

    func willChangeHangoutPosition(position: HangoutPosition) {
        videoView.buttonStack.hidden = (position == .Participant)
    }
    
}

extension PublisherViewController: OTPublisherDelegate, OTPublisherKitAudioLevelDelegate {

    func publisher(publisher: OTPublisherKit!, didFailWithError error: OTError!) {
        self.publisher = nil
        self.error = error
    }

    func publisher(publisher: OTPublisher!, didChangeCameraPosition position: AVCaptureDevicePosition) {

    }

    func publisher(publisher: OTPublisherKit!, streamCreated stream: OTStream!) {
        if let publisher = self.publisher, let publisherView = publisher.view {
            videoView.contentView = publisherView
        }
    }

    func publisher(publisher: OTPublisherKit!, streamDestroyed stream: OTStream!) {
    }

    func publisher(publisher: OTPublisherKit!, audioLevelUpdated audioLevel: Float) {
        self.audioLevel = audioLevel
    }

}