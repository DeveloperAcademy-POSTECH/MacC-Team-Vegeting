//
//  SceneDelegate.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/20.
//

import UIKit

import FirebaseAuth
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground
        
        Task {
            switch await AuthManager.shared.rootNavigationBySignInStatus() {
            case .mainTabbarController:
                window.rootViewController = MainTabBarViewController()
            case .signInViewController:
                let signInViewController = UINavigationController(rootViewController: SignInViewController())
                window.rootViewController = signInViewController
            case .userProfileViewController:
                let userProfileViewController = UINavigationController(rootViewController: UserProfileViewController())
                window.rootViewController = userProfileViewController
            }
        }
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}

