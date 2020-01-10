- [SDOSPluggableApplicationDelegate](#sdospluggableapplicationdelegate)
  - [Introduction](#introduction)
  - [Instalation](#instalation)
    - [Cocoapods](#cocoapods)
  - [At a glance. AppDelegate](#at-a-glance-appdelegate)
  - [At a glance. SceneDelegate](#at-a-glance-scenedelegate)
  - [How does this work?](#how-does-this-work)
  - [Example](#example)
  - [Requirements](#requirements)
  - [References](#references)

# SDOSPluggableApplicationDelegate

- Link confluence: https://kc.sdos.es/x/HATLAQ
- Changelog: https://github.com/SDOSLabs/SDOSPluggableApplicationDelegate/blob/master/CHANGELOG.md

## Introduction
`AppDelegate` and the new `SceneDelegate` are a traditional example of bad code. Lots of line of code that makes so much different things are put together in methods that are called within the application life cycle. But all of those concerns are over.
Using `SDOSPluggableApplicationDelegate` you decouple `AppDelegate` and `SceneDlegate` from the services that you plug to it. Each `ApplicationService` or `SceneService` have its own life cycle that is shared with `AppDelegate` or `SceneDelegate`.

## Instalation

### Cocoapods

Use [CocoaPods](https://cocoapods.org). 

Add source to `Podfile`:
```ruby
source 'https://github.com/SDOSLabs/cocoapods-specs.git'
```

Add the dependency to `Podfile`:
```ruby
pod 'SDOSPluggableApplicationDelegate', '~>2.0.1' 
```

If you want support the new `SceneDelegate` add the next dependency instead: 
```ruby
pod 'SDOSPluggableApplicationDelegate/Scene', '~>2.0.1' 
```
Remember that you need support the Scenes into your app: https://developer.apple.com/documentation/uikit/app_and_environment/scenes/specifying_the_scenes_your_app_supports

## At a glance. AppDelegate
Let see some code.
Here is how a `ApplicationService` is like:

```js
import Foundation
import SDOSPluggableApplicationDelegate

final class LoggerApplicationService: NSObject, ApplicationService {
    
    static let shared = LoggerApplicationService()
    private override init() { }
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("[APPLICATION]: It has started!")
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("[APPLICATION]: It has entered background")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("[APPLICATION]: It has become active")
    }
}
```

That's all. **It is exactly the same as a AppDelegate**. Think of `ApplicationService` as sub-AppDelegates.

In `AppDelegate` you just have to inherit from `PluggableApplicationDelegate` to register the services.

```js
import UIKit
import SDOSPluggableApplicationDelegate

@UIApplicationMain
class AppDelegate: PluggableApplicationDelegate {
    
    override var applicationServices: [ApplicationService] {
        return [
            LoggerApplicationService.shared
        ]
    }
}
```

Yes. That's all. Simple. **We recommend that the services be a singleton**
The methods of the classes register into variable `applicationServices` will be called in order every time the `AppDelegate` trigger some method. 

## At a glance. SceneDelegate

First you need support the Scenes into your app: https://developer.apple.com/documentation/uikit/app_and_environment/scenes/specifying_the_scenes_your_app_supports
Make sure you install the correct version of dependency (`SDOSPluggableApplicationDelegate/Scene`)

Here is how a `SceneService` is like:


```js
import Foundation
import SDOSPluggableApplicationDelegate

@available(iOS 13.0, *)
final class LoggerSceneService: NSObject, SceneService {
    
    static let shared = LoggerSceneService()
    private override init() { }
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("[SCENE]: It has started!")
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("[SCENE]: It has become active")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("[SCENE]: It has entered background")
    }
}
```

That's all. **It is exactly the same as a SceneService**. Think of `ServiceService` as sub-ServiceDelegates.

In `ServiceDelegate` you just have to inherit from `PluggableSceneDelegate` to register the services.

```js
import Foundation
import SDOSPluggableApplicationDelegate

@available(iOS 13.0, *)
class SceneDelegate: PluggableSceneDelegate {
    
    override var sceneServices: [SceneService] {
        return [
            LoggerSceneService.shared
        ]
    }
}
```

Also, you can unify the `ApplicationService` and `ServiceDelegate` and share the common code:

```js
import Foundation
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
```

Remember that `UIWindowSceneDelegate` is only support for iOS 13 or above, and you need implement both methods (`UIApplicationDelegate` and `UIWindowSceneDelegate`) for support previous versions of iOS

Special care about method `func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool`. This method is called for all versions of iOS, but in iOS 13 or above **you can't initialize de main view controller here**. Please be sure that you only initialize the view controller in this method for version lower that iOS 13, like the sample

## How does this work?

You may want to read the [Medium post about Pluggable App Delegate](https://medium.com/ios-os-x-development/pluggableapplicationdelegate-e50b2c5d97dd#.sz50l4d0l).
Basically, you do an inversion of control. Instead of let AppDelegate instantiate your dependencies, perform actions at every step of its life cycle, you create objects that share the AppDelegate life cycle and plug them into your AppDelegate.
Those objects are observers of the AppDelegate. Your AppDelegate has the only responsibility of notify them about its life cycle events.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

PluggableApplicationDelegate requires Swift 5.0 or above.

## References
* https://github.com/SDOSLabs/SDOSPluggableApplicationDelegate
* https://developer.apple.com/documentation/uikit/app_and_environment/scenes/specifying_the_scenes_your_app_supports
* https://github.com/fmo91/PluggableApplicationDelegate
