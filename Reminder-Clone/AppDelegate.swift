//  AppDelegate.swift
//  Reminder-Clone
//
//  Created by JK on 2021/01/03.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    // remove top line
    
    #if DEBUG
    Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
    #endif
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = UINavigationController(rootViewController: MainViewController(style: .insetGrouped))
    window?.makeKeyAndVisible()
    
    return true
  }
  
  // MARK: - Core Data stack
  
}

func homeInject(_ vc: UIViewController = MainViewController()) {
  //change vc
  //swiftlint:disable force_unwrapping
  UIApplication.shared.windows.first!.rootViewController = nil
  let vc = UINavigationController(rootViewController: MainViewController())
  UIApplication.shared.windows.first!.rootViewController = UINavigationController(rootViewController: vc)
}
