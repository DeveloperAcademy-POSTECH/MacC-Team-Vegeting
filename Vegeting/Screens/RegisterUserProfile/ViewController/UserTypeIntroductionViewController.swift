//
//  UserTypeIntroductionViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/16.
//

import UIKit

final class UserTypeIntroductionViewController: UIViewController {
    
    private var userGenderBirthYear: UserGenderBirthYear
    
    let vegetarianTypeSelectButtonTitle = "채식 단계"
    let introductionMaxLength = 60
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let progressBarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progress4")
        return imageView
    }()
    
    private let vegetarianTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        label.text = "채식단계를 선택해주세요."
        return label
    }()
    
    private lazy var vegetarianTypeSelectButton: UIButton = {
        let button = UIButton()
        button.setTitle(vegetarianTypeSelectButtonTitle, for: .normal)
        button.backgroundColor = UIColor.vfGray4
        button.setTitleColor(UIColor.vfGray3, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        button.contentHorizontalAlignment = .leading
        button.layer.cornerRadius = 8
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.addTarget(self, action: #selector(vegetarianTypeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let introductionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        label.text = "프로필 한줄 소개를 작성해주세요."
        return label
    }()
    
    private let introductionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.vfGray4
        textView.layer.cornerRadius = 8
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    
    private let introductionCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.vfGray3
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = "0/60"
        return label
    }()
    
    private let nextButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("다음으로", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(userGenderBirthYear: UserGenderBirthYear) {
        self.userGenderBirthYear = userGenderBirthYear
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView()
        configureUI()
        hideKeyboardWhenTappedAround()
        setupLayout()
    }
    
    private func configureTextView() {
        introductionTextView.delegate = self
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubviews(progressBarImageView, vegetarianTypeLabel, vegetarianTypeSelectButton,
                               introductionLabel, introductionTextView, introductionCountLabel, nextButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressBarImageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: view.frame.height * 1/10),
            progressBarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBarImageView.widthAnchor.constraint(equalToConstant: 186),
            progressBarImageView.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            vegetarianTypeLabel.topAnchor.constraint(equalTo: progressBarImageView.bottomAnchor, constant: view.frame.height * 1/10),
            vegetarianTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vegetarianTypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            vegetarianTypeSelectButton.topAnchor.constraint(equalTo: vegetarianTypeLabel.bottomAnchor, constant: 14),
            vegetarianTypeSelectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vegetarianTypeSelectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            vegetarianTypeSelectButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            introductionLabel.topAnchor.constraint(equalTo: vegetarianTypeSelectButton.bottomAnchor, constant: view.frame.height * 1/8),
            introductionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introductionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            introductionTextView.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor, constant: 14),
            introductionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introductionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            introductionTextView.heightAnchor.constraint(equalToConstant: view.frame.height * 1/7)
        ])

        NSLayoutConstraint.activate([
            introductionCountLabel.topAnchor.constraint(equalTo: introductionTextView.bottomAnchor, constant: 8),
            introductionCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            introductionCountLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -(view.frame.height * 1/2))
        ])

        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -(view.frame.height * 1/30))
        ])
    }
    
    @objc
    private func vegetarianTypeButtonTapped() {
        let modalViewController = SelectVegetarianTypeViewController()
        modalViewController.delegate = self
        modalViewController.modalPresentationStyle = .fullScreen
        present(modalViewController, animated: true)
    }
    
    private func updateIntroductionCountLabel(textLength: Int) {
        introductionCountLabel.text = "\(textLength)/\(introductionMaxLength)"
    }
    
    private func activateTextViewHighlight() {
        introductionTextView.backgroundColor = .systemBackground
        introductionTextView.layer.borderWidth = 2
        introductionTextView.layer.borderColor = UIColor.vfYellow1.cgColor
    }
    
    private func deactivateTextViewHighlight() {
        introductionTextView.backgroundColor = UIColor.vfGray4
        introductionTextView.layer.borderWidth = 0
    }
    
    private func nextButtonActive() {
        nextButton.isEnabled = true
    }
    
    @objc
    private func nextButtonTapped() {
        guard let type = vegetarianTypeSelectButton.currentTitle else { return }
        let userTypeIntroduction = UserTypeIntroduction(userGenderBirthYear: userGenderBirthYear, userVegetarianType: type, userIntroduction: introductionTextView.text)
        navigationController?.pushViewController(UserInterestViewController(userTypeIntroduction: userTypeIntroduction), animated: true)
    }
}

extension UserTypeIntroductionViewController: SelectVegetarianTypeViewDelegate {
    func didSelectVegetarianType(type: String) {
        vegetarianTypeSelectButton.setTitle(type, for: .normal)
        vegetarianTypeSelectButton.setTitleColor(.label, for: .normal)
    }
    
    func didSelectVegetarianTypeForNextButton() {
        guard let selectedType = vegetarianTypeSelectButton.titleLabel?.text else {
            return
        }
        
        if selectedType != vegetarianTypeSelectButtonTitle {
            nextButtonActive()
        }
    }
}

extension UserTypeIntroductionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        var textLength = text.count
        
        //maxLength 초과 시 키보드 내려주는 역할
        if textLength >= introductionMaxLength {
            textView.resignFirstResponder()
        }
        
        //maxLength 이상의 글자를 붙여넣을 경우 잘라주는 역할
        if textLength > introductionMaxLength {
            let index = text.index(text.startIndex, offsetBy: introductionMaxLength)
            let newString = text[text.startIndex..<index]
            introductionTextView.text = String(newString)
            textLength = newString.count
        }
        
        activateTextViewHighlight()
        updateIntroductionCountLabel(textLength: textLength)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activateTextViewHighlight()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        deactivateTextViewHighlight()
    }
}
