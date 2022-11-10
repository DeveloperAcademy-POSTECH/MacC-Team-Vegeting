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
        label.text = "모임 주제는 무엇인가요?"
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
        label.text = "모임 지역은 어디인가요?"
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .init(legibilityWeight: .bold))
        label.isHidden = true
        return label
    }()
    
    private let locationFooterLabel: UILabel = {
        let label = UILabel()
        label.text = "구체적인 장소가 정해지지 않았다면 구, 동 단위로 입력해도 좋아요!"
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.isHidden = true
        label.lineBreakMode = .byCharWrapping
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
    
    private let datePickerFooterLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘부터 한달 이내로만 모임을 만들 수 있어요."
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    private let numberOfGroupPeopleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 인원을 선택해주세요."
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .init(legibilityWeight: .bold))
        label.isHidden = true
        return label
    }()
    
    private lazy var numberOfGroupCollectionView: NumberOfGroupPeopleView = {
        let view = NumberOfGroupPeopleView()
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    private lazy var bottomButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("다음으로", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        button.isEnabled = false
        button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
        return button
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
        locationFooterLabel.isHidden = false
    }
    
    private func showDateView() {
        dateTitleLabel.isHidden = false
        datePicker.isHidden = false
        datePickerFooterLabel.isHidden = false
    }
    
    @objc
    private func showNumberOfGroupPeopleView() {
        numberOfGroupPeopleTitleLabel.isHidden = false
        numberOfGroupCollectionView.isHidden = false
    }
    
    @objc
    private func bottomButtonTapped() {
        guard let selectedCategory = categoryCollectionView.getSelectedCategory(),
              let selectedNumberOfPeople = numberOfGroupCollectionView.getSelectedNumber() else { return }
        let passedData = IncompleteClub(clubCategory: selectedCategory,
                                        clubLocation: locationLabel.text ?? "",
                                        createdAt: datePicker.date,
                                        maxNumberOfPeople: selectedNumberOfPeople)
        let viewController = SecondCreateGroupViewController()
        viewController.configure(with: passedData)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupLayout() {
        
        view.addSubviews(categoryTitleLabel,
                         categoryCollectionView,
                         locationTitleLabel,
                         locationSearchingButton,
                         locationFooterLabel,
                         dateTitleLabel,
                         datePicker,
                         datePickerFooterLabel,
                         numberOfGroupPeopleTitleLabel,
                         numberOfGroupCollectionView,
                         bottomButton)
        
        categoryTitleLabel.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                      leading: view.leadingAnchor,
                                      trailing: view.trailingAnchor,
                                      padding: UIEdgeInsets(top: 23, left: 20, bottom: 0, right: 24))
        
        categoryCollectionView.constraint(top: categoryTitleLabel.bottomAnchor,
                                          leading: view.leadingAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        locationTitleLabel.constraint(top: categoryCollectionView.bottomAnchor,
                                      leading: view.leadingAnchor,
                                      padding: UIEdgeInsets(top: 45, left: 20, bottom: 0, right: 0))
        
        locationSearchingButton.constraint(top: locationTitleLabel.bottomAnchor,
                                           leading: view.leadingAnchor,
                                           trailing: view.trailingAnchor,
                                           padding: UIEdgeInsets(top: 11, left: 20, bottom: 0, right: 20))
        locationSearchingButton.constraint(.heightAnchor, constant: 44)
        
        locationSearchingButton.addSubview(locationLabel)
        locationLabel.constraint(leading: locationSearchingButton.leadingAnchor,
                                 centerY: locationSearchingButton.centerYAnchor,
                                 padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
        locationFooterLabel.constraint(top: locationSearchingButton.bottomAnchor,
                                       leading: view.leadingAnchor,
                                       trailing: view.trailingAnchor,
                                       padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
        
        dateTitleLabel.constraint(top: locationFooterLabel.bottomAnchor,
                                  leading: view.leadingAnchor,
                                  padding: UIEdgeInsets(top: 28, left: 20, bottom: 0, right: 0))
        
        datePicker.constraint(top: dateTitleLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0))
        
        datePickerFooterLabel.constraint(top: datePicker.bottomAnchor,
                                         leading: view.leadingAnchor,
                                         padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0))
        
        numberOfGroupPeopleTitleLabel.constraint(top: datePickerFooterLabel.bottomAnchor,
                                                 leading: view.leadingAnchor,
                                                 padding: UIEdgeInsets(top: 49, left: 20, bottom: 0, right: 0))
        
        numberOfGroupCollectionView.constraint(top: numberOfGroupPeopleTitleLabel.bottomAnchor,
                                               leading: view.leadingAnchor,
                                               padding: UIEdgeInsets(top: 24, left: 20, bottom: 0, right: 0))
        
        bottomButton.constraint(leading: view.leadingAnchor,
                                bottom: view.bottomAnchor,
                                trailing: view.trailingAnchor,
                                padding: UIEdgeInsets(top: 0, left: 20, bottom: 55, right: 20))
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
    func didSelectCategory(didSelectItemAt indexPath: IndexPath) {
        self.showLocationView()
    }
}

extension FirstCreateGroupViewController: NumberOfGroupPeopleViewDelegate {
    func didSelectedItem() {
        bottomButton.isEnabled = true
    }
    
}
