//
//  EventViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/12/09.
//

import UIKit

final class EventViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "eventCuration")
        imageView.contentMode = .scaleAspectFill
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showEventDetail))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    private func setupLayout() {
        view.addSubview(imageView)
        imageView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.trailingAnchor)
        
    }
    
    @objc
    private func showEventDetail() {
        let eventDetailViewController = EventDetailViewController()
        navigationController?.pushViewController(eventDetailViewController, animated: true)
    }
}
