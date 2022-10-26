//
//  MainTabBarViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/26.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        let findClubTab = UINavigationController(rootViewController: ViewController()) //TODO: 모임 찾기 뷰로 연결
        let findFriendTab = UINavigationController(rootViewController: ViewController()) //TODO: 친구 찾기 뷰로 연결
        let chattingTab = UINavigationController(rootViewController: ViewController()) //TODO: 채팅 뷰로 연결
        let myPageTab = UINavigationController(rootViewController: ViewController()) //TODO: 마이페이지 뷰로 연결
        
        findClubTab.tabBarItem.image = UIImage(systemName: "person.3.fill")
        findFriendTab.tabBarItem.image = UIImage(systemName: "map")
        chattingTab.tabBarItem.image = UIImage(systemName: "message")
        myPageTab.tabBarItem.image = UIImage(systemName: "person")
        
        findClubTab.title = "모임 찾기"
        findFriendTab.title = "친구 찾기"
        chattingTab.title = "채팅"
        myPageTab.title = "마이페이지"
        
        tabBar.tintColor = .label
        
        setViewControllers([findClubTab, findFriendTab, chattingTab, myPageTab], animated: true)
    }
}
