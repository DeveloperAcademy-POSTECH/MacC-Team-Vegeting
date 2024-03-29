//
//  MyProfileEditViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/09.
//

import UIKit

class MyProfileEditViewController: UIViewController {
    
    private let profileView = ProfileView()
    
    private let bottomButton: BottomButton = {
       let button = BottomButton()
        button.setTitle("프로필 편집", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    private func setupLayout() {
        view.addSubviews(profileView, bottomButton)
        
        profileView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               padding: UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0))
        bottomButton.constraint(leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: view.trailingAnchor,
                                padding: UIEdgeInsets(top: 0, left: 20, bottom: 55, right: 20))
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
    }
    
    func configure(with data: Participant) {
        profileView.configure(with: data)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "내 프로필"
    }
}
