//
//  InterestView.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/03.
//

import UIKit

protocol InterestViewDelegate: AnyObject {
    func setBottomButtonEnabled(to isEnabled: Bool)
}

class InterestView: UIView {
    
    // MARK: - properties
    
    enum EntryPoint {
        case profile
        case register
    }
    
    private let interestCollectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(76),
                                              heightDimension: .absolute(37))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        collectionView.register(InterestCollectionViewCell.self, forCellWithReuseIdentifier: InterestCollectionViewCell.className)
        return collectionView
    }()
    
    private var interestList: [String]
    private var selectedInterestList: [String] = []
    private let entryPoint: EntryPoint
    
    weak var delegate: InterestViewDelegate?
    
    // MARK: - init
    
    init(interestList: [String], entryPoint: EntryPoint) {
        self.interestList = interestList
        self.entryPoint = entryPoint
        super.init(frame: .zero)
        configureCollectionView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        addSubview(interestCollectionView)
        interestCollectionView.constraint(to: self)
    }
    
    private func configureCollectionView() {
        interestCollectionView.dataSource = self
        interestCollectionView.delegate = self
    }
    
    func changeCategoryList(with list: [String]) {
        interestList = list
    }
}

extension InterestView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interestList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestCollectionViewCell.className, for: indexPath) as? InterestCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: interestList[indexPath.item])
        return cell
    }
}

extension InterestView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
       
        guard let selectedCellCount = collectionView.indexPathsForSelectedItems?.count else { return true }
        
        if selectedCellCount == 0 {
            delegate?.setBottomButtonEnabled(to: true)
            return true
        } else if selectedCellCount == 1 || selectedCellCount ==  2 {
            return true
        } else {
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        
        guard let selectedCellCount = collectionView.indexPathsForSelectedItems?.count else { return true }
        
        if selectedCellCount == 1 {
            delegate?.setBottomButtonEnabled(to: false)
            return true
        } else if selectedCellCount == 2 || selectedCellCount ==  3 {
            return true
        } else {
            return false
        }
    }
    
}
