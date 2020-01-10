//
//  PluggableApplicationDelegate.swift
//  PluggableApplicationDelegate
//
//  Created by Fernando Ortiz on 2/24/17.
//  Copyright © 2017 Fernando Martín Ortiz. All rights reserved.
//

import UIKit
import CloudKit

#if swift(>=5.1.2)
extension PluggableApplicationDelegate {
    
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
}

#endif
