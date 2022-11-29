//
//  FirstCreateGroupViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/22.
//

import UIKit
import Combine

final class FirstCreateGroupViewController: UIViewController {
    
    //MARK: - properties
    
    enum EntryPoint {
        case create
        case revise
    }
    
    private var entryPoint: EntryPoint
    var cancellables = Set<AnyCancellable>()
    private var club: Club?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 주제는 무엇인가요?"
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private lazy var categoryCollectionView: GroupCategoryView = {
        let groupCategoryView = GroupCategoryView()
        if entryPoint == .revise, let category = club?.clubCategory {
            groupCategoryView.setupPostCategory(selectedCategory: category)
        }
        groupCategoryView.delegate = self
        return groupCategoryView
    }()
    
    private let locationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 지역은 어디인가요?"
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let locationFooterLabel: UILabel = {
        let label = UILabel()
        label.text = "구체적인 장소가 정해지지 않았다면 구, 동 단위로 입력해도 좋아요!"
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .subheadline)
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
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.tintColor = .vfYellow1
        
        let now = Date()
        datePicker.minimumDate = now
        datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 1, to: now)
        datePicker.addTarget(self, action: #selector(showNumberOfGroupPeopleView), for: .valueChanged)
        return datePicker
    }()
    
    private let datePickerFooterLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘부터 한달 이내로만 모임을 만들 수 있어요."
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        return label
    }()
    
    private let numberOfGroupPeopleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 인원을 선택해주세요."
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private lazy var numberOfGroupCollectionView: NumberOfGroupPeopleView = {
        let view = NumberOfGroupPeopleView()
        if entryPoint == .revise, let maxNumber = club?.maxNumberOfPeople {
            view.setupPostNumberOfPeople(selectedNumber: maxNumber)
        }
        view.delegate = self
        return view
    }()
    
    private lazy var bottomButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("다음으로", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        button.isEnabled = entryPoint == .create ?  false : true
        button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - lifeCycle
    
    init(entryPoint: EntryPoint, club: Club? = nil) {
        self.entryPoint = entryPoint
        self.club = club
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
        setupNavigationBar()
        hideElementWhenCreateClub()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideTabBar()
    }
    
    // MARK: - func
    
    private func hideElementWhenCreateClub() {
        if entryPoint == .create {
            locationTitleLabel.isHidden = true
            locationSearchingButton.isHidden = true
            locationFooterLabel.isHidden = true
            dateTitleLabel.isHidden = true
            datePicker.isHidden = true
            datePickerFooterLabel.isHidden = true
            numberOfGroupPeopleTitleLabel.isHidden = true
            numberOfGroupCollectionView.isHidden = true
        }
    }
    
    private func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupNavigationBar() {
        self.navigationItem.backButtonDisplayMode = .minimal
    }
    
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
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
        if bottomOffset.y > 0 {
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    @objc
    private func bottomButtonTapped() {
        guard let selectedCategory = categoryCollectionView.getSelectedCategory(),
              let selectedNumberOfPeople = numberOfGroupCollectionView.getSelectedNumber() else { return }
        let passedData = IncompleteClub(clubCategory: selectedCategory,
                                        placeToMeet: locationLabel.text ?? "",
                                        dateToMeet: datePicker.date,
                                        maxNumberOfPeople: selectedNumberOfPeople)
        let viewController = SecondCreateGroupViewController()
        viewController.configure(with: passedData)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupLayout() {
        view.addSubviews(scrollView, bottomButton)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(categoryTitleLabel,
                         categoryCollectionView,
                         locationTitleLabel,
                         locationSearchingButton,
                         locationFooterLabel,
                         dateTitleLabel,
                         datePicker,
                         datePickerFooterLabel,
                         numberOfGroupPeopleTitleLabel,
                         numberOfGroupCollectionView)
        
        // MARK: - scrollView
        
        scrollView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: bottomButton.topAnchor,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              padding: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        
        contentView.constraint(top: scrollView.contentLayoutGuide.topAnchor,
                               leading: scrollView.contentLayoutGuide.leadingAnchor,
                               bottom: scrollView.contentLayoutGuide.bottomAnchor,
                               trailing: scrollView.contentLayoutGuide.trailingAnchor)
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        // MARK: - createGroupView
        
        categoryTitleLabel.constraint(top: contentView.topAnchor,
                                      leading: contentView.leadingAnchor,
                                      trailing: contentView.trailingAnchor,
                                      padding: UIEdgeInsets(top: 23, left: 20, bottom: 0, right: 24))
        
        categoryCollectionView.constraint(top: categoryTitleLabel.bottomAnchor,
                                          leading: contentView.leadingAnchor,
                                          trailing: contentView.trailingAnchor,
                                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        locationTitleLabel.constraint(top: categoryCollectionView.bottomAnchor,
                                      leading: contentView.leadingAnchor,
                                      padding: UIEdgeInsets(top: 45, left: 20, bottom: 0, right: 0))
        
        locationSearchingButton.constraint(top: locationTitleLabel.bottomAnchor,
                                           leading: contentView.leadingAnchor,
                                           trailing: contentView.trailingAnchor,
                                           padding: UIEdgeInsets(top: 11, left: 20, bottom: 0, right: 20))
        locationSearchingButton.constraint(.heightAnchor, constant: 44)
        
        locationSearchingButton.addSubview(locationLabel)
        locationLabel.constraint(leading: locationSearchingButton.leadingAnchor,
                                 centerY: locationSearchingButton.centerYAnchor,
                                 padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
        locationFooterLabel.constraint(top: locationSearchingButton.bottomAnchor,
                                       leading: contentView.leadingAnchor,
                                       trailing: contentView.trailingAnchor,
                                       padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
        
        dateTitleLabel.constraint(top: locationFooterLabel.bottomAnchor,
                                  leading: contentView.leadingAnchor,
                                  padding: UIEdgeInsets(top: 28, left: 20, bottom: 0, right: 0))
        
        datePicker.constraint(top: dateTitleLabel.bottomAnchor,
                              leading: contentView.leadingAnchor,
                              padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0))
        
        datePickerFooterLabel.constraint(top: datePicker.bottomAnchor,
                                         leading: contentView.leadingAnchor,
                                         padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0))
        
        numberOfGroupPeopleTitleLabel.constraint(top: datePickerFooterLabel.bottomAnchor,
                                                 leading: contentView.leadingAnchor,
                                                 padding: UIEdgeInsets(top: 49, left: 20, bottom: 0, right: 0))
        
        numberOfGroupCollectionView.constraint(top: numberOfGroupPeopleTitleLabel.bottomAnchor,
                                               leading: contentView.leadingAnchor,
                                               bottom: contentView.bottomAnchor,
                                               padding: UIEdgeInsets(top: 24, left: 20, bottom: 0, right: 0))
        
        bottomButton.constraint(bottom: view.bottomAnchor,
                                centerX: view.centerXAnchor,
                                padding: UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0))
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func configure(with data: Club) {
        locationLabel.text = data.placeToMeet
        datePicker.date = data.dateToMeet
    }
}

extension FirstCreateGroupViewController: LocationSearchingViewControllerDelegate {
    func configureLocationText(with text: String) {
        locationLabel.text = text
        if entryPoint == .create {
            self.showDateView()
        }
    }
}

extension FirstCreateGroupViewController: GroupCategoryViewDelegate {
    func didSelectCategory(didSelectItemAt indexPath: IndexPath) {
        if entryPoint == .create {
            self.showLocationView()
        }
    }
}

extension FirstCreateGroupViewController: NumberOfGroupPeopleViewDelegate {
    func didSelectedItem() {
        bottomButton.isEnabled = true
    }
}
