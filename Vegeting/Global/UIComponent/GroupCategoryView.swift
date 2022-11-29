//
//  GroupCategoryView.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/22.
//

import UIKit

protocol GroupCategoryViewDelegate: AnyObject {
    func didSelectCategory(didSelectItemAt indexPath: IndexPath)
}

final class GroupCategoryView: UIView {
    
    // MARK: - properties
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(GroupCategoryCollectionViewCell.self, forCellWithReuseIdentifier: GroupCategoryCollectionViewCell.className)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private var categoryList: [String] = ["맛집", "행사", "파티", "기타"]
    weak var delegate: GroupCategoryViewDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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

    func changeCategoryList(with list: [String]) {
        categoryList = list
    }
    
    func getSelectedCategory() -> String? {
        guard let index = categoryCollectionView.indexPathsForSelectedItems?.first?.item else { return nil }
        return categoryList[index]
    }
    
    func setupPostCategory(selectedCategory: String) {
        guard let index = categoryList.firstIndex(of: selectedCategory) else { return }
        let indexPath = IndexPath(item: index, section: 0)
        categoryCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
    }
}

extension GroupCategoryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCategoryCollectionViewCell.className, for: indexPath) as? GroupCategoryCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: categoryList[indexPath.item])
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
        delegate?.didSelectCategory(didSelectItemAt: indexPath)
    }
}
