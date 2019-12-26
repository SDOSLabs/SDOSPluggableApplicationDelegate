//
//  LoggerSceneService.swift
//  SDOSPluggableApplicationDelegateExample
//
//  Created by Rafael Fernandez Alvarez on 26/12/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import SDOSPluggableApplicationDelegate

@available(iOS 13.0, *)
final class LoggerSceneService: NSObject, SceneService {
    
    static let shared = LoggerSceneService()
    private override init() { }
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        print("[SCENE]: It has started!")
        
        if let contentView = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ViewController {
            contentView.text = "Load from Scene"
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = contentView
                self.window = window
                window.makeKeyAndVisible()
            }
        }

        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("[SCENE]: It has become active")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("[SCENE]: It has entered background")
    }
}
