//
//  FirstCreateGroupViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/22.
//

import UIKit

final class FirstCreateGroupViewController: UIViewController {
    
    //MARK: - properties
    
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임의 목적을 선택해주세요."
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let categoryCollectionView = GroupCategoryView()
    
    private let locationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지역을 선택해주세요."
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let locationContrainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜를 선택해주세요."
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval(2678400)
        return datePicker
    }()
    
    private let numberOfGroupPeopleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 인원을 선택해주세요."
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let numberOfGroupCollectionView = NumberOfGroupPeopleView()
    
    //MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
    }
    
    //MARK: - func
    
    private func setupLayout() {
        view.addSubview(categoryTitleLabel)
        categoryTitleLabel.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                      leading: view.leadingAnchor,
                                      trailing: view.trailingAnchor,
                                      padding: UIEdgeInsets(top: 23, left: 24, bottom: 0, right: 24))
        
        view.addSubview(categoryCollectionView)
        categoryCollectionView.constraint(top: categoryTitleLabel.bottomAnchor,
                                          leading: view.leadingAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        view.addSubview(locationTitleLabel)
        locationTitleLabel.constraint(top: categoryCollectionView.bottomAnchor,
                                      leading: view.leadingAnchor,
                                      padding: UIEdgeInsets(top: 49, left: 24, bottom: 0, right: 0))
        
        view.addSubview(locationContrainerView)
        locationContrainerView.constraint(top: locationTitleLabel.bottomAnchor,
                                          leading: view.leadingAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: 10, left: 24, bottom: 0, right: 24))
        locationContrainerView.constraint(.heightAnchor, constant: 44)
        
        view.addSubview(dateTitleLabel)
        dateTitleLabel.constraint(top: locationContrainerView.bottomAnchor,
                                  leading: view.leadingAnchor,
                                  padding: UIEdgeInsets(top: 49, left: 24, bottom: 0, right: 0))
        
        view.addSubview(datePicker)
        datePicker.constraint(top: dateTitleLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              padding: UIEdgeInsets(top: 10, left: 24, bottom: 0, right: 0))
        
        view.addSubview(numberOfGroupPeopleTitleLabel)
        numberOfGroupPeopleTitleLabel.constraint(top: datePicker.bottomAnchor,
                                                 leading: view.leadingAnchor,
                                                 padding: UIEdgeInsets(top: 49, left: 24, bottom: 0, right: 0))
        
        view.addSubview(numberOfGroupCollectionView)
        numberOfGroupCollectionView.constraint(top: numberOfGroupPeopleTitleLabel.bottomAnchor,
                                               leading: view.leadingAnchor,
                                               padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 0))
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
}
