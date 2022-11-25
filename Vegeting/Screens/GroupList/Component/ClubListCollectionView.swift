//
//  ClubListCollectionView.swift
//  Vegeting
//
//  Created by kelly on 2022/11/21.
//

import UIKit

protocol ClubListCollectionViewDelegate: AnyObject {
    func clubListCellTapped(viewController: PostDetailViewController)
}

class ClubListCollectionView: UICollectionView {
    private var clubList: [Club] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
        }
    }
    
    weak var tapDelegate: ClubListCollectionViewDelegate?
    
    // MARK: - init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        super.init(frame: frame, collectionViewLayout: layout)
        configureUI()
        configureCollectionView()
    }
    
    // MARK: - func
    
    private func configureUI() {
        self.backgroundColor = .clear
        self.register(ClubListCollectionViewCell.self, forCellWithReuseIdentifier: ClubListCollectionViewCell.className)
        self.showsVerticalScrollIndicator = false
    }
    
    private func configureCollectionView() {
        self.delegate = self
        self.dataSource = self
    }
    
    func setClubList(clubList: [Club]) {
        self.clubList = clubList
    }
}

extension ClubListCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(AuthManager.shared.getCurrentUser())
        Task {
            guard let currentUser = AuthManager.shared.getCurrentUser() else { return }
            let selectedClub = clubList[indexPath.item]
            let isMine = currentUser.userID == selectedClub.hostID
            let detailViewController = PostDetailViewController(club: clubList[indexPath.item], entryPoint: isMine ? .mine : .other)
            tapDelegate?.clubListCellTapped(viewController: detailViewController)
        }
    }
}

extension ClubListCollectionView: UICollectionViewDataSource {
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

extension ClubListCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20) / 2, height: 165)
    }
}
