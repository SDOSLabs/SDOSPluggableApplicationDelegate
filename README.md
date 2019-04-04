- [SDOSPluggableApplicationDelegate](#sdospluggableapplicationdelegate)
  - [Introduction](#introduction)
  - [Instalación](#instalaci%C3%B3n)
    - [Cocoapods](#cocoapods)
  - [At a glance](#at-a-glance)
  - [How does this work?](#how-does-this-work)
  - [Example](#example)
  - [Requirements](#requirements)
  - [References](#references)

# SDOSPluggableApplicationDelegate

- Link confluence: https://kc.sdos.es/x/HATLAQ

## Introduction
`AppDelegate` is a traditional example of bad code. Lots of line of code that makes so much different things are put together in methods that are called within the application life cycle. But all of those concerns are over.
Using `SDOSPluggableApplicationDelegate` you decouple AppDelegate from the services that you plug to it. Each `ApplicationService` has its own life cycle that is shared with `AppDelegate`. 

## Instalación

### Cocoapods

Use [CocoaPods](https://cocoapods.org). Add the dependency to `Podfile`:

```ruby
pod 'SDOSPluggableApplicationDelegate', '~>1.0.0' 
```

## At a glance
Let see some code.
Here is how a `ApplicationService` is like:

```js
import Foundation
import PluggableApplicationDelegate

final class LoggerApplicationService: NSObject, ApplicationService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("It has started!")
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("It has entered background")
    }
}
```

That's all. **It is exactly the same as a AppDelegate**. Think of `ApplicationService` as sub-AppDelegates.

In `AppDelegate` you just have to inherit from PluggableApplicationDelegate to register the services.

```js
import UIKit
import PluggableApplicationDelegate

@UIApplicationMain
class AppDelegate: PluggableApplicationDelegate {
    
    override var services: [ApplicationService] {
        return [
            LoggerApplicationService()
        ]
    }
}
```

Yes. That's all. Simple.

The func `public func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?)` and need implement in the main AppDelegate if you want override

## How does this work?

You may want to read the [Medium post about Pluggable App Delegate](https://medium.com/ios-os-x-development/pluggableapplicationdelegate-e50b2c5d97dd#.sz50l4d0l).
Basically, you do an inversion of control. Instead of let AppDelegate instantiate your dependencies, perform actions at every step of its life cycle, you create objects that share the AppDelegate life cycle and plug them into your AppDelegate.
Those objects are observers of the AppDelegate. Your AppDelegate has the only responsibility of notify them about its life cycle events.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

PluggableApplicationDelegate requires Swift 5.0 or above.

## References
* https://svrgitpub.sdos.es/iOS/SDOSPluggableApplicationDelegate
