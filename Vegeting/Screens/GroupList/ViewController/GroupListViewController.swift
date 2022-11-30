//
//  GroupListViewController.swift
//  Vegeting
//
//  Created by kelly on 2022/10/26.
//

import UIKit

class GroupListViewController: UIViewController {
    private var showClubList: [Club] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateCollectionViewList()
            }
        }
    }
    
    private var allClubList = [Club]()
    private var restaurantClubList = [Club]()
    private var eventClubList = [Club]()
    private var elseClubList = [Club]()
    
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
    
    private lazy var addClubButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration.init(pointSize: 18, weight: .regular)
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(addClubButtontapped), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func addClubButtontapped() {
        let creatrViewController = FirstCreateGroupViewController()
        navigationController?.pushViewController(creatrViewController, animated: true)
    }
    
    private lazy var groupCategoryView: GroupCategoryView = {
        let groupCategoryView = GroupCategoryView()
        groupCategoryView.changeCategoryList(with: ["전체", "맛집", "행사", "기타"])
        groupCategoryView.delegate = self
        return groupCategoryView
    }()
    
    private lazy var collectionView: ClubListCollectionView = {
        let collectionView = ClubListCollectionView()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshClubList), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.tapDelegate = self
        return collectionView
    }()
    
    //MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomNavigationBar()
        configureUI()
        setupLayout()
        groupCategoryView.setupDefaultStatus()
        refreshClubList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
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
        navigationBarView.addArrangedSubviews(navigationTitleLabel, addClubButton)
        let space = view.frame.width - navigationTitleLabel.frame.width
        navigationBarView.spacing = space - 70

        navigationItem.titleView = navigationBarView
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupLayout() {
        view.addSubviews(groupCategoryView, collectionView)
        
        NSLayoutConstraint.activate([
            groupCategoryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            groupCategoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            groupCategoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            groupCategoryView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: groupCategoryView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func refreshClubList(){
        Task {
            resetClubArray()
            allClubList = await FirebaseManager.shared.requestClubInformation() ?? []
            fetchClubLists()
            updateShowClubList()
            updateCollectionViewList()
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func fetchClubLists() {
        for club in allClubList {
            switch club.clubCategory {
            case "맛집" :
                restaurantClubList.append(club)
            case "행사" :
                eventClubList.append(club)
            case "기타" :
                elseClubList.append(club)
            default :
                break
            }
        }
    }
    
    private func updateShowClubList() {
        switch groupCategoryView.getSelectedCategory() {
        case "전체" :
            showClubList = allClubList
        case "맛집" :
            showClubList = restaurantClubList
        case "행사" :
            showClubList = eventClubList
        case "기타" :
            showClubList = elseClubList
        default :
            groupCategoryView.setupDefaultStatus()
            showClubList = allClubList
        }
    }
    
    private func updateCollectionViewList() {
        self.collectionView.setClubList(clubList: showClubList)
    }
    
    private func resetClubArray() {
        restaurantClubList = []
        eventClubList = []
        elseClubList = []
    }
}

extension GroupListViewController: GroupCategoryViewDelegate {
    func didSelectCategory(didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            showClubList = allClubList
        case 1:
            showClubList = restaurantClubList
        case 2:
            showClubList = eventClubList
        case 3:
            showClubList = elseClubList
        default:
            break
        }
    }
}

extension GroupListViewController: ClubListCollectionViewDelegate {
    func clubListCellTapped(viewController: PostDetailViewController) {
        hideTabBar()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
