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
//        MARK: 앱을 처음 켰을때 나오게 되는 화면
        Task {
            switch await AuthManager.shared.rootNavigationBySignInStatus() {
            case .mainTabbarController:
                window.rootViewController = MainTabBarViewController()
            case .signInViewController:
                let signInViewController = UINavigationController(rootViewController: SignInViewController())
                window.rootViewController = signInViewController
            case .userProfileViewController:
                let firstProfileViewController = UINavigationController(rootViewController: FirstProfileViewController())
                window.rootViewController = firstProfileViewController
            }
        }
        //        MARK: 앱에서 로그인 상태가 변했을 때 바뀌는 화면
        NotificationCenter.default.addObserver(forName: NSNotification.Name("sceneRootViewToMainTabbar"), object: nil, queue: nil) { _ in
            window.rootViewController = MainTabBarViewController()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("sceneRootViewToSignInViewController"), object: nil, queue: nil) { _ in
            let signInViewController = UINavigationController(rootViewController: SignInViewController())
            window.rootViewController = signInViewController
        }
        
        window.backgroundColor = .systemBackground
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

