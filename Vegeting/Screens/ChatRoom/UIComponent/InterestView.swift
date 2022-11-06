//
//  InterestView.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/03.
//

import UIKit

class InterestView: UIView {
    
    // MARK: - properties
    
    enum EntryPoint {
        case profile
        case register
    }
    
    private let interestCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumInteritemSpacing = 14
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(InterestCollectionViewCell.self, forCellWithReuseIdentifier: InterestCollectionViewCell.className)
        return collectionView
    }()
    
    private var interestList: [String]
    private var selectedInterestList: [String] = []
    private let entryPoint: EntryPoint
    
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
        interestCollectionView.constraint(.heightAnchor, constant: 139)
        interestCollectionView.constraint(.widthAnchor, constant: 270)
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

extension InterestView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = interestList[indexPath.item].size(withAttributes: [.font : UIFont.preferredFont(forTextStyle: .subheadline)]).width + 50
        
        return CGSize(width: width, height: 34)
    }
}

extension InterestView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch entryPoint {
            
        case .profile:
            return
        case .register:
            if selectedInterestList.count < 3 {
                guard let cell = interestCollectionView.cellForItem(at: indexPath) as? InterestCollectionViewCell else { return }
                selectedInterestList.append(interestList[indexPath.item])
                cell.applySelectedState()
            }
        }
        
    }
}
