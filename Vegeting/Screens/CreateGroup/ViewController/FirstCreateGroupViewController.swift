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
    
    private lazy var categoryCollectionView: GroupCategoryView = {
        let view = GroupCategoryView()
        view.delegate = self
        return view
    }()
    
    private let locationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지역을 선택해주세요."
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .init(legibilityWeight: .bold))
        label.isHidden = true
        return label
    }()
    
    private lazy var locationSearchingButton: UIButton = {
        let button = UIButton(primaryAction: UIAction { _ in
            let viewController = LocationSearchingViewController()
            viewController.delegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        })
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 7
        button.isHidden = true
        return button
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
        label.isHidden = true
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval(2678400)
        datePicker.isHidden = true
        datePicker.addTarget(self, action: #selector(showNumberOfGroupPeopleView), for: .valueChanged)
        return datePicker
    }()
    
    private let numberOfGroupPeopleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 인원을 선택해주세요."
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .init(legibilityWeight: .bold))
        label.isHidden = true
        return label
    }()
    
    private let numberOfGroupCollectionView: NumberOfGroupPeopleView = {
        let view = NumberOfGroupPeopleView()
        view.isHidden = true
        return view
    }()
    
    //MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
    }
    
    //MARK: - func
    
    private func showLocationView() {
        locationTitleLabel.isHidden = false
        locationSearchingButton.isHidden = false
    }
    
    private func showDateView() {
        dateTitleLabel.isHidden = false
        datePicker.isHidden = false
    }
    
    @objc
    private func showNumberOfGroupPeopleView() {
        numberOfGroupPeopleTitleLabel.isHidden = false
        numberOfGroupCollectionView.isHidden = false
    }
    
    private func setupLayout() {
        view.addSubviews(categoryTitleLabel,
                         categoryCollectionView,
                         locationTitleLabel,
                         locationSearchingButton,
                         dateTitleLabel,
                         datePicker,
                         numberOfGroupPeopleTitleLabel,
                         numberOfGroupCollectionView)
        
        categoryTitleLabel.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                      leading: view.leadingAnchor,
                                      trailing: view.trailingAnchor,
                                      padding: UIEdgeInsets(top: 23, left: 24, bottom: 0, right: 24))
        
        categoryCollectionView.constraint(top: categoryTitleLabel.bottomAnchor,
                                          leading: view.leadingAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        locationTitleLabel.constraint(top: categoryCollectionView.bottomAnchor,
                                      leading: view.leadingAnchor,
                                      padding: UIEdgeInsets(top: 49, left: 24, bottom: 0, right: 0))
        
        locationSearchingButton.constraint(top: locationTitleLabel.bottomAnchor,
                                          leading: view.leadingAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: 10, left: 24, bottom: 0, right: 24))
        locationSearchingButton.constraint(.heightAnchor, constant: 44)
        
        locationSearchingButton.addSubview(locationLabel)
        locationLabel.constraint(leading: locationSearchingButton.leadingAnchor,
                                 centerY: locationSearchingButton.centerYAnchor,
                                 padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
        dateTitleLabel.constraint(top: locationSearchingButton.bottomAnchor,
                                  leading: view.leadingAnchor,
                                  padding: UIEdgeInsets(top: 49, left: 24, bottom: 0, right: 0))
        
        datePicker.constraint(top: dateTitleLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              padding: UIEdgeInsets(top: 10, left: 24, bottom: 0, right: 0))
        
        numberOfGroupPeopleTitleLabel.constraint(top: datePicker.bottomAnchor,
                                                 leading: view.leadingAnchor,
                                                 padding: UIEdgeInsets(top: 49, left: 24, bottom: 0, right: 0))
        
        numberOfGroupCollectionView.constraint(top: numberOfGroupPeopleTitleLabel.bottomAnchor,
                                               leading: view.leadingAnchor,
                                               padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 0))
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }

}

extension FirstCreateGroupViewController: LocationSearchingViewControllerDelegate {
    func configureLocationText(with text: String) {
        locationLabel.text = text
        self.showDateView()
    }
    
}

extension FirstCreateGroupViewController: GroupCategoryViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showLocationView()
    }
    
}
