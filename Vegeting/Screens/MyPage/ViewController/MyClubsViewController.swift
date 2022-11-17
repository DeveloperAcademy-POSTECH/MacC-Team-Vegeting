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
                self?.collectionView.reloadData()
            }
            setupLayout()
        }
    }

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
        
        configureCollectionView()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    // MARK: - func
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func hideTabBar() {
        tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.height)
    }

    private func showTabBar() {
        let tabBarheight = tabBarController?.tabBar.frame.height ?? 0
        tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.height - (tabBarheight + 1))
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "참여한 모임"
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

extension MyClubsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO : 모임글 선택하면 해당 모임글의 상세화면으로 넘어가기
    }
}

extension MyClubsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myClubList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClubListCollectionViewCell.className, for: indexPath) as? ClubListCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: myClubList[indexPath.item])
        return cell
    }
}

extension MyClubsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20) / 2, height: 165)
    }
}
