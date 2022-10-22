//
//  GroupCategoryView.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/22.
//

import UIKit

final class GroupCategoryView: UIView {
    
    // MARK: - properties
    
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let categoryList: [String] = ["행사", "맛집", "친목", "공부", "기타", "하나더"]
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        addSubview(categoryCollectionView)
        categoryCollectionView.constraint(to: self)
        categoryCollectionView.constraint(.heightAnchor, constant: 60)
    }
    
    private func configureCollectionView() {
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(GroupCategoryCollectionViewCell.self, forCellWithReuseIdentifier: GroupCategoryCollectionViewCell.className)
        
    }
}

extension GroupCategoryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCategoryCollectionViewCell.className, for: indexPath) as? GroupCategoryCollectionViewCell else { return UICollectionViewCell()}
        
        cell.setItemLabel(with: categoryList[indexPath.item])
        return cell
    }
}

extension GroupCategoryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = categoryList[indexPath.item].size(withAttributes: [.font : UIFont.preferredFont(forTextStyle: .subheadline)]).width + 40
        
        return CGSize(width: width, height: 34)
    }
}

extension GroupCategoryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("하이")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCategoryCollectionViewCell.className, for: indexPath) as? GroupCategoryCollectionViewCell else { return }
                
        cell.applySelectedState(true)
    
    }
}
