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
open class MultipleServicesManager: UIResponder, SceneDelegate, ApplicationDelegate {
    
    public var window: UIWindow?
    
    open var sceneServices: [SceneService] { return [] }
    private lazy var __sceneServices: [SceneService] = {
        return self.sceneServices
    }()
    
    open var applicationServices: [ApplicationService] { return [] }
    private lazy var __applicationServices: [ApplicationService] = {
        return self.applicationServices
    }()
    
}

//Application
@available(iOS 13.0, *)
extension MultipleServicesManager {
    @discardableResult
        private func applyToApplication<T, S>(_ work: (ApplicationService, @escaping (T) -> Void) -> S?, completionHandler: @escaping ([T]) -> Swift.Void) -> [S] {
            let dispatchGroup = DispatchGroup()
            var results: [T] = []
            var returns: [S] = []
            
            for service in __applicationServices {
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
        
        open func applicationDidFinishLaunching(_ application: UIApplication) {
            __applicationServices.forEach { $0.applicationDidFinishLaunching?(application) }
        }
        
        open func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            var result = false
            for service in __applicationServices {
                if service.application?(application, willFinishLaunchingWithOptions: launchOptions) ?? false {
                    result = true
                }
            }
            return result
        }
        
        open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            var result = false
            for service in __applicationServices {
                if service.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? false {
                    result = true
                }
            }
            return result
        }
        
        open func applicationDidBecomeActive(_ application: UIApplication) {
            for service in __applicationServices {
                service.applicationDidBecomeActive?(application)
            }
        }
    
        open func applicationWillResignActive(_ application: UIApplication) {
            for service in __applicationServices {
                service.applicationWillResignActive?(application)
            }
        }
        
        @available(iOS, deprecated: 9.0, message: "Please use application:openURL:options:")
        open func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
            var result = false
            for service in __applicationServices {
                if service.application?(application, handleOpen: url) ?? false {
                    result = true
                }
            }
            return result
        }
        
        @available(iOS, deprecated: 9.0, message: "Please use application:openURL:options:")
        open func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
            var result = false
            for service in __applicationServices {
                if service.application?(application, open: url, sourceApplication: sourceApplication, annotation: annotation) ?? false {
                    result = true
                }
            }
            return result
        }
        
        open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            var result = false
            for service in __applicationServices {
                if service.application?(app, open: url, options: options) ?? false {
                    result = true
                }
            }
            return result
        }
        
        open func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
            for service in __applicationServices {
                service.applicationDidReceiveMemoryWarning?(application)
            }
        }
        
        open func applicationWillTerminate(_ application: UIApplication) {
            for service in __applicationServices {
                service.applicationWillTerminate?(application)
            }
        }
        
        open func applicationSignificantTimeChange(_ application: UIApplication) {
            for service in __applicationServices {
                service.applicationSignificantTimeChange?(application)
            }
        }
        
        open func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval) {
            for service in __applicationServices {
                service.application?(application, willChangeStatusBarOrientation: newStatusBarOrientation, duration: duration)
            }
        }
        
        open func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation) {
            for service in __applicationServices {
                service.application?(application, didChangeStatusBarOrientation: oldStatusBarOrientation)
            }
        }
        
        open func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
            for service in __applicationServices {
                service.application?(application, willChangeStatusBarFrame: newStatusBarFrame)
            }
        }

        open func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
            for service in __applicationServices {
                service.application?(application, didChangeStatusBarFrame: oldStatusBarFrame)
            }
        }
        
        
        // This callback will be made upon calling -[UIApplication registerUserNotificationSettings:]. The settings the user has granted to the application will be passed in as the second argument.
        @available(iOS, deprecated: 10.0, message: "Use UserNotification UNNotification Settings instead")
        open func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
            for service in __applicationServices {
                service.application?(application, didRegister: notificationSettings)
            }
        }
        
        open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            for service in __applicationServices {
                service.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
            }
        }
        
        open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            for service in __applicationServices {
                service.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)
            }
        }
        
        
        @available(iOS, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications")
        open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
            for service in __applicationServices {
                service.application?(application, didReceiveRemoteNotification: userInfo)
            }
        }
        
        
        @available(iOS, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
        open func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
            for service in __applicationServices {
                service.application?(application, didReceive: notification)
            }
        }
        
        
        // Called when your app has been activated by the user selecting an action from a local notification.
        // A nil action identifier indicates the default action.
        // You should call the completion handler as soon as you've finished handling the action.
        @available(iOS, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
        open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
            applyToApplication({ (service, completion) -> Void? in
                service.application?(application, handleActionWithIdentifier: identifier, for: notification) {
                    completion(())
                }
            }, completionHandler: { _ in
                completionHandler()
            })
        }
        
        
        @available(iOS, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
        open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void) {
            applyToApplication({ (service, completionHandler) -> Void? in
                service.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, withResponseInfo: responseInfo) {
                    completionHandler(())
                }
            }, completionHandler: { _ in
                completionHandler()
            })
        }
        
        
        // Called when your app has been activated by the user selecting an action from a remote notification.
        // A nil action identifier indicates the default action.
        // You should call the completion handler as soon as you've finished handling the action.
        @available(iOS, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
        open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void) {
            applyToApplication({ (service, completionHandler) -> Void? in
                service.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo) {
                    completionHandler(())
                }
            }, completionHandler: { _ in
                completionHandler()
            })
        }
        
        
        @available(iOS, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
        open func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void) {
            applyToApplication({ (service, completionHandler) -> Void? in
                service.application?(application, handleActionWithIdentifier: identifier, for: notification, withResponseInfo: responseInfo) {
                    completionHandler(())
                }
            }, completionHandler: { _ in
                completionHandler()
            })
        }
        
        
        /*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
         
         This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
        open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
            applyToApplication({ (service, completionHandler) -> Void? in
                service.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
            }, completionHandler: { results in
                let result = results.min(by: { $0.rawValue < $1.rawValue }) ?? .noData
                completionHandler(result)
            })
        }
        
        
        /// Applications with the "fetch" background mode may be given opportunities to fetch updated content in the background or when it is convenient for the system. This method will be called in these situations. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
        open func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
            applyToApplication({ (service, completionHandler) -> Void? in
                service.application?(application, performFetchWithCompletionHandler: completionHandler)
            }, completionHandler: { results in
                let result = results.min(by: { $0.rawValue < $1.rawValue }) ?? .noData
                completionHandler(result)
            })
        }
        
        
        // Called when the user activates your application by selecting a shortcut on the home screen,
        // except when -application:willFinishLaunchingWithOptions: or -application:didFinishLaunchingWithOptions returns NO.
        open func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Swift.Void) {
            applyToApplication({ (service, completionHandler) -> Void? in
                service.application?(application, performActionFor: shortcutItem, completionHandler: completionHandler)
            }, completionHandler: { results in
                // if any service handled the shortcut, return true
                let result = results.reduce(false, { $0 || $1 })
                completionHandler(result)
            })
        }
        
        
        // Applications using an NSURLSession with a background configuration may be launched or resumed in the background in order to handle the
        // completion of tasks in that session, or to handle authentication. This method will be called with the identifier of the session needing
        // attention. Once a session has been created from a configuration object with that identifier, the session's delegate will begin receiving
        // callbacks. If such a session has already been created (if the app is being resumed, for instance), then the delegate will start receiving
        // callbacks without any action by the application. You should call the completionHandler as soon as you're finished handling the callbacks.
        open func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Swift.Void) {
            applyToApplication({ (service, completionHandler) -> Void? in
                service.application?(application, handleEventsForBackgroundURLSession: identifier) {
                    completionHandler(())
                }
            }, completionHandler: { _ in
                completionHandler()
            })
        }
        
        open func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Swift.Void) {
            for service in __applicationServices {
                service.application?(application, handleWatchKitExtensionRequest: userInfo, reply: reply)
            }
            applyToApplication({ (service, reply) -> Void? in
                service.application?(application, handleWatchKitExtensionRequest: userInfo, reply: reply)
            }, completionHandler: { results in
                let result = results.reduce([:], { initial, next in
                    var initial = initial
                    for (key, value) in next ?? [:] {
                        initial[key] = value
                    }
                    return initial
                })
                reply(result)
            })
        }
        
        open func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
            for service in __applicationServices {
                service.applicationShouldRequestHealthAuthorization?(application)
            }
        }
        
        open func applicationDidEnterBackground(_ application: UIApplication) {
            for service in __applicationServices {
                service.applicationDidEnterBackground?(application)
            }
        }
        
        open func applicationWillEnterForeground(_ application: UIApplication) {
            for service in __applicationServices {
                service.applicationWillEnterForeground?(application)
            }
        }
        
        open func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
            for service in __applicationServices {
                service.applicationProtectedDataWillBecomeUnavailable?(application)
            }
        }
        
        open func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
            for service in __applicationServices {
                service.applicationProtectedDataDidBecomeAvailable?(application)
            }
        }
        
        
        // Applications may reject specific types of extensions based on the extension point identifier.
        // Constants representing common extension point identifiers are provided further down.
        // If unimplemented, the default behavior is to allow the extension point identifier.
        open func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
            var result = false
            for service in __applicationServices {
                if service.application?(application, shouldAllowExtensionPointIdentifier: extensionPointIdentifier) ?? true {
                    result = true
                }
            }
            return result
        }
        
        
        public func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
            for service in __applicationServices {
                if let viewController = service.application?(application, viewControllerWithRestorationIdentifierPath: identifierComponents, coder: coder) {
                    print("[SDOSPluggableApplicationDelegate] - Return first responder of \(#function)")
                    return viewController
                }
            }
            
            return nil
        }

    @available(iOS, deprecated: 13.2, message: "Use application:shouldSaveSecureApplicationState: instead")
    open func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        var result = false
        for service in __applicationServices {
            if service.application?(application, shouldSaveApplicationState: coder) ?? false {
                result = true
            }
        }
        return result
    }
    
    @available(iOS 13.2, *)
    public func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        var result = false
        for service in __applicationServices {
            if service.application?(application, shouldSaveSecureApplicationState: coder) ?? false {
                result = true
            }
        }
        return result
    }
    
    @available(iOS, deprecated: 13.2, message: "Use application:shouldRestoreSecureApplicationState: instead")
    open func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        var result = false
        for service in __applicationServices {
            if service.application?(application, shouldRestoreApplicationState: coder) ?? false {
                result = true
            }
        }
        return result
    }
    
    @available(iOS 13.2, *)
    public func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        var result = false
        for service in __applicationServices {
            if service.application?(application, shouldRestoreSecureApplicationState: coder) ?? false {
                result = true
            }
        }
        return result
    }
        
        open func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
            for service in __applicationServices {
                service.application?(application, willEncodeRestorableStateWith: coder)
            }
        }
        
        open func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
            for service in __applicationServices {
                service.application?(application, didDecodeRestorableStateWith: coder)
            }
        }
        
        
        // Called on the main thread as soon as the user indicates they want to continue an activity in your application. The NSUserActivity object may not be available instantly,
        // so use this as an opportunity to show the user that an activity will be continued shortly.
        // For each application:willContinueUserActivityWithType: invocation, you are guaranteed to get exactly one invocation of application:continueUserActivity: on success,
        // or application:didFailToContinueUserActivityWithType:error: if an error was encountered.
        open func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
            var result = false
            for service in __applicationServices {
                if service.application?(application, willContinueUserActivityWithType: userActivityType) ?? false {
                    result = true
                }
            }
            return result
        }
        
        
        // Called on the main thread after the NSUserActivity object is available. Use the data you stored in the NSUserActivity object to re-create what the user was doing.
        // You can create/fetch any restorable objects associated with the user activity, and pass them to the restorationHandler. They will then have the UIResponder restoreUserActivityState: method
        // invoked with the user activity. Invoking the restorationHandler is optional. It may be copied and invoked later, and it will bounce to the main thread to complete its work and call
        // restoreUserActivityState on all objects.
        public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
            let returns = applyToApplication({ (service, restorationHandler) -> Bool? in
                service.application?(application, continue: userActivity, restorationHandler: restorationHandler)
            }, completionHandler: { results in
                let result = results.reduce([], { $0 + ($1 ?? []) })
                restorationHandler(result)
            })
            
            return returns.reduce(false, { $0 || $1 })
        }
        
        
        // If the user activity cannot be fetched after willContinueUserActivityWithType is called, this will be called on the main thread when implemented.
        open func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
            for service in __applicationServices {
                service.application?(application, didFailToContinueUserActivityWithType: userActivityType, error: error)
            }
        }
        
        
        // This is called on the main thread when a user activity managed by UIKit has been updated. You can use this as a last chance to add additional data to the userActivity.
        open func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
            for service in __applicationServices {
                service.application?(application, didUpdate: userActivity)
            }
        }
        
        
        // This will be called on the main thread after the user indicates they want to accept a CloudKit sharing invitation in your application.
        // You should use the CKShareMetadata object's shareURL and containerIdentifier to schedule a CKAcceptSharesOperation, then start using
        // the resulting CKShare and its associated record(s), which will appear in the CKContainer's shared database in a zone matching that of the record's owner.
        open func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
            for service in __applicationServices {
                service.application?(application, userDidAcceptCloudKitShareWith: cloudKitShareMetadata)
            }
        }
        
        //MARK: - SceneKit
        
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

        open func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
            __applicationServices.forEach { $0.application?(application, didDiscardSceneSessions: sceneSessions) }
        }
}

//Scenes
@available(iOS 13.0, *)
extension MultipleServicesManager {
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

#endif

