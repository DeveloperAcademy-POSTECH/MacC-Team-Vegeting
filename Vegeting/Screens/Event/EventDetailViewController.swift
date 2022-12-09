//
//  EventDetailViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/12/09.
//

import UIKit

final class EventDetailViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "eventDetail")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(imageView)
        imageView.constraint(top: view.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.trailingAnchor)
    }
    
}
