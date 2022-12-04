//
//  GroupListViewController.swift
//  Vegeting
//
//  Created by kelly on 2022/10/26.
//

import UIKit

class GroupListViewController: UIViewController {
    private var clubList: [Club] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    private lazy var navigationBarView: UIStackView = {
        let hStackView = UIStackView()
        hStackView.setHorizontalStack()
        return hStackView
    }()
    
    private lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 중인 모임"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.sizeToFit()
        return label
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration.init(pointSize: 18, weight: .regular)
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(searchButtontapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var addClubButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration.init(pointSize: 18, weight: .regular)
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(addClubButtontapped), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func searchButtontapped() {
        print("tapSearchButton")
    }
    
    @objc
    private func addClubButtontapped() {
        let createViewController = FirstCreateGroupViewController(createGroupEntryPoint: .create)
        navigationController?.pushViewController(createViewController, animated: true)
    }
    
    private lazy var customSegmentedControl: SegmentedControlCustomView = {
        let segmentedControl = SegmentedControlCustomView()
        return segmentedControl
    }()
    
    private lazy var collectionView: ClubListCollectionView = {
        let collectionView = ClubListCollectionView()
        collectionView.tapDelegate = self
        return collectionView
    }()
    
    //MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomNavigationBar()
        configureUI()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
        Task { [weak self] in
            let clubList = await FirebaseManager.shared.requestClubInformation() ?? []
            self?.collectionView.setClubList(clubList: clubList)
        }
    }
    
    //MARK: - func
    
    private func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func hideTabBar() {
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setCustomNavigationBar() {
        let rightButtonStackView = UIStackView()
        rightButtonStackView.setHorizontalStack()
        rightButtonStackView.spacing = 15
        rightButtonStackView.addArrangedSubviews(searchButton, addClubButton)
        
        navigationBarView.addArrangedSubviews(navigationTitleLabel, rightButtonStackView)
        let space = view.frame.width - navigationTitleLabel.frame.width
        navigationBarView.spacing = space - 115

        navigationItem.titleView = navigationBarView
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupLayout() {
        view.addSubviews(customSegmentedControl, collectionView)
        
        NSLayoutConstraint.activate([
            customSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            customSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension GroupListViewController: ClubListCollectionViewDelegate {
    func clubListCellTapped(viewController: PostDetailViewController) {
        hideTabBar()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
