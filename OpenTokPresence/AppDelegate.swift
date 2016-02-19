//
//  AppDelegate.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/16/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var heightMultiplier : CGFloat {
        let bounds = UIScreen.mainScreen().bounds
        return bounds.width / bounds.height
    }

    func fakeViewController(backgroundColor: UIColor? = nil) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = backgroundColor
        vc.view.widthAnchor.constraintEqualToAnchor(vc.view.heightAnchor, multiplier: heightMultiplier).active = true
        return vc
    }

    func configureHangout() {
        let r = fakeViewController(UIColor.redColor())
        let b = fakeViewController(UIColor.blueColor())
        let g = fakeViewController(UIColor.yellowColor())


        let overlay = HangoutViewController()
        overlay.participantViewControllers = [r, b, g]

        window?.rootViewController = overlay
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let navigationController = UINavigationController(rootViewController: PresenceViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

