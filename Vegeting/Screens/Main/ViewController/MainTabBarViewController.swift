//
//  MainTabBarViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/26.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    private let findClubTab: UINavigationController = {
        let controller = UINavigationController(rootViewController: ViewController()) //TODO: 모임 찾기 뷰로 연결
        controller.tabBarItem.image = UIImage(systemName: "person.3.fill")
        controller.title = "모임 찾기"
        return controller
    }()
    
    private let findFriendTab: UINavigationController = {
        let controller = UINavigationController(rootViewController: ViewController()) //TODO: 친구 찾기 뷰로 연결
        controller.tabBarItem.image = UIImage(systemName: "map")
        controller.title = "친구 찾기"
        return controller
    }()
    
    private let chattingTab: UINavigationController = {
        let controller = UINavigationController(rootViewController: ViewController()) //TODO: 채팅 뷰로 연결
        controller.tabBarItem.image = UIImage(systemName: "message")
        controller.title = "채팅"
        return controller
    }()
    
    private let myPageTab: UINavigationController = {
        let controller = UINavigationController(rootViewController: ViewController()) //TODO: 마이페이지 뷰로 연결
        controller.tabBarItem.image = UIImage(systemName: "person")
        controller.title = "마이페이지"
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        configureUI()
        
        setViewControllers([findClubTab, findFriendTab, chattingTab, myPageTab], animated: true)
    }
    
    func configureTabBar() {
        tabBar.tintColor = .label
    }
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
}
