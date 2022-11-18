//
//  InterestView.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/03.
//

import UIKit

protocol InterestViewDelegate: AnyObject {
    func setBottomButtonEnabled(selectedList: [String])
}

class InterestView: UIView {
    
    // MARK: - properties
    
    enum EntryPoint {
        case profile
        case register
    }
    
    private let interestCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
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
            guard let cell = interestCollectionView.cellForItem(at: indexPath) as? InterestCollectionViewCell else { return }
            cell.isSelectedCell.toggle()
            
            if cell.isSelectedCell && selectedInterestList.count < 3 {
                selectedInterestList.append(interestList[indexPath.item])
                cell.applySelectedState()
            } else {
                guard let index = selectedInterestList.firstIndex(of: interestList[indexPath.item]) else { return }
                selectedInterestList.remove(at: index)
                cell.applySelectedState()
            }
            delegate?.setBottomButtonEnabled(selectedList: self.selectedInterestList)
        }
    }
    
}
