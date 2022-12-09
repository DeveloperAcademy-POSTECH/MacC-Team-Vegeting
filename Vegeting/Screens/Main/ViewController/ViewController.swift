//
//  ViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/20.
//

import UIKit

final class ViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "eventDetail")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setupLayout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            NotificationCenter.default.post(name: NSNotification.Name("didLaunchScreenEnded"), object: nil)
        })
    }
    
    private func setupLayout() {
        view.addSubview(imageView)
        imageView.constraint(top: view.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.trailingAnchor)
    }
    
}

