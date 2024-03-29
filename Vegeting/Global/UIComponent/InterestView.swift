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

final class InterestView: UIView {
    
    // MARK: - properties
    
    enum EntryPoint {
        case profile
        case register
    }
    
    var isOtherOption = true
  
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
    private var selectedInterestList = [Int:String]()
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
        fatalError()
    }
    
    // MARK: - func
    
    private func setupLayout() {
        addSubview(interestCollectionView)
        interestCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            interestCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            interestCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            interestCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            interestCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
    }
    
    private func configureCollectionView() {
        interestCollectionView.dataSource = self
        interestCollectionView.delegate = self
    }
    
    func changeCategoryList(with list: [String]) {
        DispatchQueue.main.async { [weak self] in
            self?.interestList = list
            self?.interestCollectionView.reloadData()
        }
    }
    
    func deliverInterestList() -> [String] {
        var selectedList = selectedInterestList.map({ (key, value) -> String in
            return value
        })
        
        return selectedList
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
        switch entryPoint {
        case .profile:
            return false
        case .register:
            guard let selectedCellCount = interestCollectionView.indexPathsForSelectedItems?.count else { return true }
            
            if 0 <= selectedCellCount  && selectedCellCount <= 2 {
                return true
            } else {
                return false
            }
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selectedInterestList[indexPath.item] = interestList[indexPath.item]
            judgeBottomButtonEnabled(status: true, targetValue: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            selectedInterestList[indexPath.item] = nil
            judgeBottomButtonEnabled(status: false, targetValue: 0)
    }
    
    private func judgeBottomButtonEnabled(status: Bool, targetValue: Int) {
        guard let selectedCellCount = interestCollectionView.indexPathsForSelectedItems?.count else { return }
        if selectedCellCount == targetValue {
            delegate?.setBottomButtonEnabled(to: status)
        }
    }
}
