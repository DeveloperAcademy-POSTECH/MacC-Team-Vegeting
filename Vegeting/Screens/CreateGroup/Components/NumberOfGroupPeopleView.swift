//
//  NumberOfGroupPeopleView.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/23.
//

import UIKit

protocol NumberOfGroupPeopleViewDelegate: AnyObject {
    func didSelectedItem()
}

final class NumberOfGroupPeopleView: UIView {
    
    // MARK: - properties
    
    private let numberCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(NumberOfPeopleCollectionViewCell.self, forCellWithReuseIdentifier: NumberOfPeopleCollectionViewCell.className)
        return collectionView
    }()
    
    private let numberList: [String] = ["2명", "3명", "4명", "5명", "6명", "7명", "8명"]
    weak var delegate: NumberOfGroupPeopleViewDelegate?
    
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
        addSubview(numberCollectionView)
        numberCollectionView.constraint(to: self)
        numberCollectionView.constraint(.heightAnchor, constant: 80)
        numberCollectionView.constraint(.widthAnchor, constant: 290)
    }
    
    private func configureCollectionView() {
        numberCollectionView.dataSource = self
        numberCollectionView.delegate = self
    }
    
    func getSelectedNumber() -> Int? {
        guard let index = numberCollectionView.indexPathsForSelectedItems?.first?.item else { return nil }
        return index + 2
    }
    
    func setupPostNumberOfPeople(selectedNumber: Int) {
        let numberInString = "\(selectedNumber)명"
        guard let index = numberList.firstIndex(of: numberInString) else { return }
        let indexPath = IndexPath(item: index, section: 0)
        numberCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
    }
}

extension NumberOfGroupPeopleView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberOfPeopleCollectionViewCell.className, for: indexPath) as? NumberOfPeopleCollectionViewCell else { return UICollectionViewCell()}
        cell.setItemLabel(with: numberList[indexPath.item])
        return cell
    }
}

extension NumberOfGroupPeopleView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 34)
    }
}

extension NumberOfGroupPeopleView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectedItem()
    }
}
