//
//  AppDelegate.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = DiEatTabBarController(tab: .calorie)
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
