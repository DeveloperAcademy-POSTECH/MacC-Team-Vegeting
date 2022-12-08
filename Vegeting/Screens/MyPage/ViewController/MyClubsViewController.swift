//
//  MyClubsViewController.swift
//  Vegeting
//
//  Created by kelly on 2022/11/14.
//

import UIKit

class MyClubsViewController: UIViewController {
    private var myClubList: [Club] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateCollectionViewList()
            }
            setupLayout()
        }
    }

    private lazy var collectionView: ClubListCollectionView = {
        let collectionView = ClubListCollectionView()
        collectionView.tapDelegate = self
        return collectionView
    }()
    
    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 참여한 모임이 없어요.\n 관심있는 주제의 모임에 참여해보세요."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
        Task { [weak self] in
            self?.myClubList = await FirebaseManager.shared.requestMyClubInformation() ?? []
        }
    }
    
    // MARK: - func
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "참여한 모임"
    }
    
    private func updateCollectionViewList() {
        self.collectionView.setClubList(clubList: myClubList)
    }
    
    private func setupLayout() {
        if myClubList.isEmpty {
            setupEmptyViewLayout()
        } else {
            setupCollectionViewLayout()
        }
    }
    
    private func setupCollectionViewLayout() {
        view.addSubviews(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupEmptyViewLayout() {
        view.addSubviews(emptyLabel, emptyImageView)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            emptyImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.bottomAnchor.constraint(equalTo: emptyLabel.topAnchor, constant: -30),
            emptyImageView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
}

extension MyClubsViewController: ClubListCollectionViewDelegate {
    func clubListCellTapped(viewController: PostDetailViewController) {
        hideTabBar()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

