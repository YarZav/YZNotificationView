//
//  AppDelegate.swift
//  YZNotificationViewExample
//
//  Created by admin on 29.03.2019.
//  Copyright © 2019 Yaroslav Zavyalov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.getRootNavigationController()
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

// MARK: - Privates
extension AppDelegate {
    
    private func getRootNavigationController() -> UINavigationController {
        let rootViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        return navigationController
    }
}

// MARK: - Don't used
extension AppDelegate {
    func applicationWillResignActive(_ application: UIApplication) { }
    func applicationDidEnterBackground(_ application: UIApplication) { }
    func applicationWillEnterForeground(_ application: UIApplication) { }
    func applicationDidBecomeActive(_ application: UIApplication) { }
    func applicationWillTerminate(_ application: UIApplication) { }
}

