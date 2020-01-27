//
//  AppDelegate.swift
//  albelliTest
//
//  Created by Alex Yaroshyn on 08/01/2020.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // MARK: - App Lifecycle
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        setRootVC()
        
        return true
    }
    
    // MARK: - Helper
    private func setRootVC() {
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: ImageCollectionVC())
        window?.makeKeyAndVisible()
    }
}
