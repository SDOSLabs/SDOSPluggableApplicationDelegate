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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("It has started!")
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("It has entered background")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("It has become active")
    }
}
