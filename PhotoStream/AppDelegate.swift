//
//  AppDelegate.swift
//  PhotoStream
//
//  Created by HDimes on 10/8/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit
import MVNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = PhotoStreamViewController()
        
        DataManager.shared.concurrentRequest = 1
        DataManager.shared.maxCacheSize = 100
        
        return true
    }

}

