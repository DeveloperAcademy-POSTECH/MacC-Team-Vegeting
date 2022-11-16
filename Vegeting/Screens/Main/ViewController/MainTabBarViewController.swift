//
//  MainTabBarViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/26.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    private let findClubTab: UINavigationController = {
        let controller = UINavigationController(rootViewController: GroupListViewController()) //TODO: 모임 찾기 뷰로 연결
        controller.tabBarItem.image = UIImage(named: "clubStroke")
        controller.tabBarItem.selectedImage = UIImage(named: "clubFill")
        controller.title = "모임 찾기"
        return controller
    }()
    
    private let findFriendTab: UINavigationController = {
        let controller = UINavigationController(rootViewController: ViewController()) //TODO: 친구 찾기 뷰로 연결
        controller.tabBarItem.image = UIImage(named: "calanderStroke")
        controller.tabBarItem.selectedImage = UIImage(named: "calanderFill")
        controller.title = "친구 찾기"
        return controller
    }()
    
    private let chattingTab: UINavigationController = {
        let controller = UINavigationController(rootViewController: ChatRoomListViewController()) //TODO: 채팅 뷰로 연결
        let imageConfig = UIImage.SymbolConfiguration.init(pointSize: 14, weight: .medium)
        controller.tabBarItem.image = UIImage(systemName: "message", withConfiguration: imageConfig)
        controller.tabBarItem.selectedImage = UIImage(systemName: "message.fill", withConfiguration: imageConfig)
        controller.title = "채팅"
        return controller
    }()
    
    private let myPageTab: UINavigationController = {
        let controller = UINavigationController(rootViewController: MyPageViewController()) //TODO: 마이페이지 뷰로 연결
        controller.tabBarItem.image = UIImage(named: "mypageStroke")
        controller.tabBarItem.selectedImage = UIImage(named: "mypageFill")
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
        tabBar.tintColor = .black
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .systemBackground
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    func configureUI() {
        tabBar.backgroundColor = .white
        view.backgroundColor = .white
    }
    
}
