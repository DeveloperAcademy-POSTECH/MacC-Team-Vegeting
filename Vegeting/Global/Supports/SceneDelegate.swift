//
//  SceneDelegate.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
             let window = UIWindow(windowScene: windowScene)
            let navigation = UINavigationController(rootViewController: FirstCreateGroupViewController())
        
             window.rootViewController = navigation
             window.makeKeyAndVisible()
             self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

}

