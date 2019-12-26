//
//  PluggableApplicationDelegate.swift
//  PluggableApplicationDelegate
//
//  Created by Fernando Ortiz on 2/24/17.
//  Copyright © 2017 Fernando Martín Ortiz. All rights reserved.
//

import UIKit
import CloudKit

#if swift(>=5.1)

@available(iOS 13.0, *)
public typealias SceneDelegate = UIWindowSceneDelegate

@available(iOS 13.0, *)
public protocol SceneService: SceneDelegate {}

@available(iOS 13.0, *)
open class PluggableSceneDelegate: UIResponder, SceneDelegate {
    
    public var window: UIWindow?
    
    open var sceneServices: [SceneService] { return [] }
    internal lazy var __sceneServices: [SceneService] = {
        return self.sceneServices
    }()
    
    
    @discardableResult
    private func applyToScene<T, S>(_ work: (SceneService, @escaping (T) -> Void) -> S?, completionHandler: @escaping ([T]) -> Swift.Void) -> [S] {
        let dispatchGroup = DispatchGroup()
        var results: [T] = []
        var returns: [S] = []
        
        for service in __sceneServices {
            dispatchGroup.enter()
            let returned = work(service, { result in
                results.append(result)
                dispatchGroup.leave()
            })
            if let returned = returned {
                returns.append(returned)
            } else { // delegate doesn't impliment method
                dispatchGroup.leave()
            }
            if returned == nil {
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completionHandler(results)
        }
        
        return returns
    }
    
    @available(iOS 13.0, *)
    open func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        __sceneServices.forEach { $0.scene?(scene, willConnectTo: session, options: connectionOptions) }
    }
    
    @available(iOS 13.0, *)
    open func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
        __sceneServices.forEach { $0.windowScene?(windowScene, didUpdate: previousCoordinateSpace, interfaceOrientation: previousInterfaceOrientation, traitCollection: previousTraitCollection) }
    }

    @available(iOS 13.0, *)
    open func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        applyToScene({ (service, completionHandler) -> Void in
            service.windowScene?(windowScene, performActionFor: shortcutItem) { result in
                completionHandler(result)
            }
        }, completionHandler: { results in
            let result = results.reduce(false, { $0 || $1 })
            completionHandler(result)
        })
    }

    
    @available(iOS 13.0, *)
    open func windowScene(_ windowScene: UIWindowScene, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        __sceneServices.forEach { $0.windowScene?(windowScene, userDidAcceptCloudKitShareWith: cloudKitShareMetadata) }
    }
    
    @available(iOS 13.0, *)
    open func sceneDidDisconnect(_ scene: UIScene) {
        __sceneServices.forEach { $0.sceneDidDisconnect?(scene) }
    }
    
    @available(iOS 13.0, *)
    open func sceneDidBecomeActive(_ scene: UIScene) {
        __sceneServices.forEach { $0.sceneDidBecomeActive?(scene) }
    }

    @available(iOS 13.0, *)
    open func sceneWillResignActive(_ scene: UIScene) {
        __sceneServices.forEach { $0.sceneWillResignActive?(scene) }
    }

    @available(iOS 13.0, *)
    open func sceneWillEnterForeground(_ scene: UIScene) {
        __sceneServices.forEach {$0.sceneWillEnterForeground?(scene) }
    }

    @available(iOS 13.0, *)
    open func sceneDidEnterBackground(_ scene: UIScene) {
        __sceneServices.forEach { $0.sceneDidEnterBackground?(scene) }
    }
    

    @available(iOS 13.0, *)
    open func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        __sceneServices.forEach { $0.scene?(scene, openURLContexts: URLContexts) }
    }
    
    @available(iOS 13.0, *)
    open func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        for service in __sceneServices {
            if let result = service.stateRestorationActivity?(for: scene) {
                print("[SDOSPluggableApplicationDelegate] - Return first responder of \(#function)")
                return result
            }
        }
        return nil
    }

    @available(iOS 13.0, *)
    open func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
        __sceneServices.forEach { $0.scene?(scene, willContinueUserActivityWithType: userActivityType) }
    }

    @available(iOS 13.0, *)
    open func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        __sceneServices.forEach { $0.scene?(scene, continue: userActivity) }
    }

    @available(iOS 13.0, *)
    open func scene(_ scene: UIScene, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        __sceneServices.forEach { $0.scene?(scene, didFailToContinueUserActivityWithType: userActivityType, error: error) }
    }

    @available(iOS 13.0, *)
    open func scene(_ scene: UIScene, didUpdate userActivity: NSUserActivity) {
        __sceneServices.forEach { $0.scene?(scene, didUpdate: userActivity) }
    }
    
}

@available(iOS 13.0, *)
extension PluggableApplicationDelegate {
    
    //MARK: - SceneKit
    
    @available(iOS 13.0, *)
    open func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        for service in __applicationServices {
            if let result = service.application?(application, configurationForConnecting: connectingSceneSession, options: options) {
                print("[SDOSPluggableApplicationDelegate] - Return first responder of \(#function)")
                return result
            }
        }
        
        print("[SDOSPluggableApplicationDelegate] - Any service implement \(#function). Return a default configuration")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    open func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        __applicationServices.forEach { $0.application?(application, didDiscardSceneSessions: sceneSessions) }
    }
}

#endif
