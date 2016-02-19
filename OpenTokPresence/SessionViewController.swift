//
//  SessionViewController.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/16/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import Alamofire

class SessionViewController: UIViewController {
    let manager: Manager
    let hangoutViewController = HangoutViewController()
    var publisherViewController: PublisherViewController?
    var session: OTSession?
    var sessionRequest: Request?

    var currentViewController: UIViewController?

    var sessionState: SessionState {
        didSet {
            let newVC = viewControllerForSessionState(sessionState)
            let currentVC = currentViewController

            addChildViewController(newVC)
            view.addSubview(newVC.view)
            newVC.view.translatesAutoresizingMaskIntoConstraints = false
            newVC.view.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor).active = true
            newVC.view.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor).active = true
            newVC.view.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true
            newVC.view.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true

            currentVC?.willMoveToParentViewController(nil)

            currentViewController = newVC
            UIView.animateWithDuration(0.25, delay: 0, options: .TransitionCrossDissolve, animations: { () -> Void in

                }, completion: { completed in
                    newVC.didMoveToParentViewController(self)
                    currentVC?.view.removeFromSuperview()
                    currentVC?.removeFromParentViewController()
            })
        }
    }

    func viewControllerForSessionState(sessionState: SessionState) -> UIViewController {
        switch sessionState {
        case .Connected:
            return hangoutViewController
        default:
            return EmptyStateViewController(state: sessionState)
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.manager = Manager()
        self.sessionState = .Connecting
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SessionViewController {

    func setupSession(apiKey: String, sessionId: String, token: String) {
        let session = OTSession(apiKey: apiKey, sessionId: sessionId, delegate: self)
        var error: OTError?
        session!.connectWithToken(token, error: &error)
        if let error = error {
            sessionState = .Error(message:error.localizedDescription)
        }
        else {
            self.session = session
            publisherViewController = PublisherViewController(session: session)
            hangoutViewController.participantViewControllers.append(publisherViewController!)
        }
    }


    func addParticipantForStream(stream: OTStream) {
        guard let session = session else {
            fatalError("Can not add participant without a stream")
        }
        let subscriberVC = SubscriberViewController(session: session)
        hangoutViewController.participantViewControllers.insert(subscriberVC, atIndex: 0)
        subscriberVC.subscribe(stream)
    }

    func removeParticipantForStream(stream: OTStream) {
        var participantIndex: Int? = nil
        for (index, vc) in hangoutViewController.participantViewControllers.enumerate() {
            if let subscriberVC = vc as? SubscriberViewController {
                if subscriberVC.subscriber?.stream.streamId == stream.streamId {
                    participantIndex = index
                    break
                }
            }
        }
        if let participantIndex = participantIndex {
            hangoutViewController.participantViewControllers.removeAtIndex(participantIndex)
        }
    }

}


extension SessionViewController : OTSessionDelegate {

    func sessionDidConnect(session: OTSession!) {
        self.sessionState = .Connected
        if let publisherViewController = publisherViewController {
            publisherViewController.publish()
        }
    }

    func sessionDidDisconnect(session: OTSession!) {
        self.sessionState = .Completed(message:"Session Complete")
    }

    func sessionDidBeginReconnecting(session: OTSession!) {
        self.sessionState = .Connecting
    }

    func sessionDidReconnect(session: OTSession!) {
        self.sessionState = .Connected
    }

    func session(session: OTSession!, didFailWithError error: OTError!) {
        self.sessionState = .Error(message:error.localizedDescription)
    }

    func session(session: OTSession!, streamCreated stream: OTStream!) {
        addParticipantForStream(stream)
    }

    func session(session: OTSession!, streamDestroyed stream: OTStream!) {
        removeParticipantForStream(stream)
    }

    func session(session: OTSession!, receivedSignalType type: String!, fromConnection connection: OTConnection!, withString string: String!) {
        print("\(type) == \(string)")
    }

}
