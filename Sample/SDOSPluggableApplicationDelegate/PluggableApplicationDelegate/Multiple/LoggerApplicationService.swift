//
//  LoggerApplicationService.swift
//  PluggableApplicationDelegate
//
//  Created by Fernando Ortiz on 2/25/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SDOSPluggableApplicationDelegate

final class LoggerApplicationService: NSObject, ApplicationService, SceneService {
    
    static let shared = LoggerApplicationService()
    private override init() { }
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("[APPLICATION]: It has started!")
        if #available(iOS 13.0, *) {} else {
            loadViewController(window: UIWindow(frame: UIScreen.main.bounds), text: "Load from Application")
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("[APPLICATION]: It has become active")
        didBecomeActive()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("[APPLICATION]: It has entered background")
        didEnterBackground()
    }
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("[SCENE]: It has started!")
        if let windowScene = scene as? UIWindowScene {
            loadViewController(window: UIWindow(windowScene: windowScene), text: "Load from Scene")
        }
    }
    
    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("[SCENE]: It has become active")
        didBecomeActive()
    }
    
    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("[SCENE]: It has entered background")
        didEnterBackground()
    }
    
    //MARK: - Private methods
    
    private func loadViewController(window: UIWindow, text: String) {
        print("[COMMON]: It has started!")
        if let contentView = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ViewController {
            contentView.text = text
            window.rootViewController = contentView
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    private func didEnterBackground() {
        print("[COMMON]: It has entered background")
    }
    
    private func didBecomeActive() {
        print("[COMMON]: It has become active")
    }
}
