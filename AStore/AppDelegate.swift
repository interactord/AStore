//
//  AppDelegate.swift
//  AStore
//
//  Created by SANGBONG MOON on 2019-04-20.
//  Copyright © 2019 Scott Moon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = BaseTabBarController()
    window?.makeKeyAndVisible()

    return true
  }

}
