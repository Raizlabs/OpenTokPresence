//
//  PresenceViewController.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/18/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import Alamofire

class PresenceViewController: UITableViewController {

    let presence = PresenceService()

    var buddyList = BuddyList(users:[]) {
        didSet { tableView.reloadData() }
    }
    
    var session: OTSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellClass(UserTableViewCell.self)
        tableView.registerCellClass(InviteTableViewCell.self)
        tableView.registerCellClass(EmptyTableViewCell.self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        register()
    }
}

extension PresenceViewController {

    func register() {
        guard session == nil else {
            return
        }
        presence.fetchPresence { response in
            if let sessionResponse = response.value {
                self.session = OTSession(apiKey: sessionResponse.apiKey, sessionId: sessionResponse.sessionId, delegate: self)
                self.presence.registerUser(UIDevice.currentDevice().name) { response in
                    if let token = response.value, let session = self.session {
                        var error: OTError?
                        session.connectWithToken(token, error: &error)
                        self.handleError(error)
                    }
                    else {
                        self.handleError(response.error)
                        self.session = nil
                    }
                }
            }
            else {
                self.handleError(response.error)
            }
        }
    }

    func presentSession(chatResult: Result<PresenceService.ChatResponse, NSError>) {
        if let chatResponse = chatResult.value {
            let sessionViewController = SessionViewController()
            sessionViewController.setupSession(chatResponse.apiKey, sessionId: chatResponse.sessionId, token: chatResponse.token)
            self.navigationController?.pushViewController(sessionViewController, animated: true)
        }
        else {
            handleError(chatResult.error)
        }
    }

    func handleError(error: NSError?) {
        if let error = error {
            print(error)
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}

extension PresenceViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return buddyList.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buddyList.numberOfRowsInSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = buddyList.rowAtIndexPath(indexPath)
        switch row {
        case .Empty(let emptyDescription):
            let cell: EmptyTableViewCell = tableView.cellForIndexPath(indexPath)
            cell.textLabel?.text = emptyDescription
            return cell
        case .User(let remoteUser):
            let cell: UserTableViewCell = tableView.cellForIndexPath(indexPath)
            cell.textLabel?.text = remoteUser.name
            cell.detailTextLabel?.text = remoteUser.status.displayStatus
            return cell
        case .Invite(let remoteUser):
            let cell: InviteTableViewCell = tableView.cellForIndexPath(indexPath)
            cell.textLabel?.text = "Invitation from \(remoteUser.name)"
            return cell
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = buddyList.rowAtIndexPath(indexPath)
        switch row {
        case .Empty(_):
            break
        case let .User(remoteUser):
            if let session = session {
                presence.initiateChat(remoteUser) { result in
                    if let response = result.value {
                        let invitation = Message.Invitation(identifier: remoteUser.identifier, sessionId: response.sessionId, apiKey: response.apiKey)
                        let (type, message) = invitation.toSignal()
                        var error: OTError? = nil
                        session.signalWithType(type, string: message, connection: nil, error: &error)
                        self.presentSession(result)
                    }
                    else {
                        self.handleError(result.error!)
                    }
                }
            }
        case .Invite(let remoteUser):
            presence.joinChat(remoteUser, completion: presentSession)
        }
    }

}

extension PresenceViewController : OTSessionDelegate {

    func session(session: OTSession!, didFailWithError error: OTError!) {
        handleError(error)
    }

    func session(session: OTSession!, receivedSignalType type: String!, fromConnection connection: OTConnection!, withString string: String!) {
        guard let message = Message.fromSignal(type, withString:string, fromConnectionId:connection?.connectionId) else {
            return
        }
        switch message {
        case let .Status(identifier, status):
            buddyList.updateStatus(identifier, status: status)
        case let .Invitation(identifier, sessionId, _):
            buddyList.invite(identifier, invitationSessionId: sessionId)
            break;
        case let .CancelInvitation(identifier, _, _):
            buddyList.cancelInvite(identifier)
            break
        }
    }

    func session(session: OTSession!, connectionCreated connection: OTConnection!) {
        guard
            let data = connection.data.dataUsingEncoding(NSUTF8StringEncoding),
            let JSONObject = try? NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments]),
            let JSON = JSONObject as? Dictionary<String, String>,
            let name = JSON[APIConstants.SessionKeys.name] else
        {
            return
        }
        buddyList.connect(connection.connectionId, name: name)
    }

    func session(session: OTSession!, connectionDestroyed connection: OTConnection!) {
        buddyList.disconnect(connection.connectionId)
    }

    func session(session: OTSession!, streamCreated stream: OTStream!) {    }
    func session(session: OTSession!, streamDestroyed stream: OTStream!) {    }
    func sessionDidConnect(session: OTSession!) {    }
    func sessionDidDisconnect(session: OTSession!) {    }
    func sessionDidBeginReconnecting(session: OTSession!) {    }
    func sessionDidReconnect(session: OTSession!) {    }

}
