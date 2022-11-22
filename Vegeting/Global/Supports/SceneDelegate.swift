//
//  SceneDelegate.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/20.
//

import UIKit
import KakaoSDKAuth 

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
<<<<<<< HEAD
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = MainTabBarViewController()
            window.makeKeyAndVisible()
            self.window = window
=======
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainTabBarViewController()
        window.makeKeyAndVisible()
        self.window = window
>>>>>>> ddc38890cb5eb75159004b064b41861681215164
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}

