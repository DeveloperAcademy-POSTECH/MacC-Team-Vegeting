//
//  ViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/20.
//

import UIKit

import Lottie

final class LaunchScreenViewController: UIViewController {
    
    private let animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "launchScreenLottie")
        animationView.loopMode = .playOnce
        return animationView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setupLayout()
        animationView.play { _ in
            NotificationCenter.default.post(name: NSNotification.Name("didLaunchScreenEnded"), object: nil)
        }
    }
    
    private func setupLayout() {
        view.addSubview(animationView)
        animationView.constraint(top: view.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.trailingAnchor)
    }
    
}

