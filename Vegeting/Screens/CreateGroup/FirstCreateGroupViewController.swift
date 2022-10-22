//
//  FirstCreateGroupViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/22.
//

import UIKit

final class FirstCreateGroupViewController: UIViewController {
    
    //MARK: - properties
    
    private let categoryTitleLabel: UILabel = {
       let label = UILabel()
        label.text = "모임의 목적을 선택해주세요."
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let categoryCollectionView = GroupCategoryView()
    
    //MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
    }
    
    //MARK: - func
    
    private func setupLayout() {
        view.addSubview(categoryTitleLabel)
        categoryTitleLabel.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                      leading: view.leadingAnchor,
                                      padding: UIEdgeInsets(top: 23, left: 24, bottom: 0, right: 0))
        
        view.addSubview(categoryCollectionView)
        categoryCollectionView.constraint(top: categoryTitleLabel.bottomAnchor,
                                          leading: view.leadingAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }

    private func configureUI() {
        view.backgroundColor = .yellow
    }
}
