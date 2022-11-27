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
    
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(GroupCategoryCollectionViewCell.self, forCellWithReuseIdentifier: GroupCategoryCollectionViewCell.className)
        return collectionView
    }()
    
    private var categoryList: [String] = ["맛집", "행사", "파티", "기타"]
    weak var delegate: GroupCategoryViewDelegate?
    
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
        addSubviews(categoryCollectionView)
        
        NSLayoutConstraint.activate([
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 40),
            categoryCollectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func configureCollectionView() {
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
    }
    
    func selectAllCategory() {
        guard let selectedIndex = categoryCollectionView.indexPathsForSelectedItems else { return }
        if !selectedIndex.isEmpty {
            categoryCollectionView.deselectItem(at: selectedIndex[0], animated: false)
            guard let cellToDeselect = categoryCollectionView.cellForItem(at: selectedIndex[0]) as? GroupCategoryCollectionViewCell else { return }
            cellToDeselect.applySelectedState()
        }
        
        let fisrtIndexPath = IndexPath(item: 0, section: 0)
        guard let cellToSelect = categoryCollectionView.cellForItem(at: fisrtIndexPath) as? GroupCategoryCollectionViewCell else { return }
        categoryCollectionView.selectItem(at: fisrtIndexPath, animated: false , scrollPosition: .init())
        cellToSelect.applySelectedState()
    }
    
    func changeCategoryList(with list: [String]) {
        categoryList = list
    }
    
    func getSelectedCategory() -> String? {
        guard let index = categoryCollectionView.indexPathsForSelectedItems?.first?.item else { return nil }
        return categoryList[index]
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
        return CGSize(width: 70, height: 33)
    }
}

extension GroupCategoryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GroupCategoryCollectionViewCell else { return }
        delegate?.didSelectCategory(didSelectItemAt: indexPath)
        cell.applySelectedState()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GroupCategoryCollectionViewCell else { return }
        cell.applySelectedState()
    }
}
