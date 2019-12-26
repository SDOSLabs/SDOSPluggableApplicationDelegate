//
//  SceneDelegate.swift
//  SDOSPluggableApplicationDelegateExample
//
//  Created by Rafael Fernandez Alvarez on 26/12/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

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
