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
                self?.collectionView.reloadData()
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
        print("tapAddClubButton")
    }
    
    private lazy var groupCategoryView: GroupCategoryView = {
        let groupCategoryView = GroupCategoryView()
        groupCategoryView.changeCategoryList(with: ["전체", "맛집", "행사", "기타"])
        groupCategoryView.delegate = self
        return groupCategoryView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ClubListCollectionViewCell.self, forCellWithReuseIdentifier: ClubListCollectionViewCell.className)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomNavigationBar()
        configureCollectionView()
        configureUI()
        setupLayout()
        groupCategoryView.setupDefaultStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            allClubList = await FirebaseManager.shared.requestClubInformation() ?? []
            fetchClubLists()
            updateShowClubList()
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
        print(groupCategoryView.getSelectedCategory())
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
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setCustomNavigationBar() {
        navigationBarView.addArrangedSubviews(navigationTitleLabel, addClubButton)
        let space = view.frame.width - navigationTitleLabel.frame.width
        navigationBarView.spacing = space - 70

        navigationItem.titleView = navigationBarView
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

extension GroupListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(showClubList[indexPath.item])
    }
}

extension GroupListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showClubList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClubListCollectionViewCell.className, for: indexPath) as? ClubListCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: showClubList[indexPath.item])
        return cell
    }
}

extension GroupListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20) / 2, height: 165)
    }
}
