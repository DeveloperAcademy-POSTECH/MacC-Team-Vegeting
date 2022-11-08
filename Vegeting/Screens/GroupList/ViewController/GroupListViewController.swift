//
//  GroupListViewController.swift
//  Vegeting
//
//  Created by kelly on 2022/10/26.
//

import UIKit

class GroupListViewController: UIViewController {
    private var clubList = GroupList.mockData {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }

    private let participants = Participant.mockData
    
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
        button.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var addClubButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration.init(pointSize: 18, weight: .regular)
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(tapAddClubButton), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func tapSearchButton() {
        print("tapSearchButton")
    }
    
    @objc
    private func tapAddClubButton() {
        print("tapAddClubButton")
    }
    
    private lazy var customSegmentedControl: SegmentedControlCustomView = {
        let segmentedControl = SegmentedControlCustomView()
        return segmentedControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
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
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
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
    }
    
    private func setupLayout() {
        view.addSubviews(customSegmentedControl, collectionView)
        
        NSLayoutConstraint.activate([
            customSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            customSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

extension GroupListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(clubList[indexPath.item])
    }
}

extension GroupListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clubList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClubListCollectionViewCell.className, for: indexPath) as? ClubListCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: clubList[indexPath.item])
        return cell
    }
}

extension GroupListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20) / 2, height: 210)
    }
}
