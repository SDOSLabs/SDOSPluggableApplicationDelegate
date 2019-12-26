//
//  LoggerApplicationService.swift
//  PluggableApplicationDelegate
//
//  Created by Fernando Ortiz on 2/25/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import SDOSPluggableApplicationDelegate

final class LoggerApplicationService: NSObject, ApplicationService {
    
    static let shared = LoggerApplicationService()
    private override init() { }
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("[APPLICATION]: It has started!")
        
        if let contentView = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ViewController {
            contentView.text = "Load from Application"
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = contentView
            self.window = window
            window.makeKeyAndVisible()
        }
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("[APPLICATION]: It has entered background")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("[APPLICATION]: It has become active")
    }
}
