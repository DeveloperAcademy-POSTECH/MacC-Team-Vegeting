//
//  UserGenderBirthViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/06.
//

import UIKit

final class UserGenderBirthViewController: UIViewController {
    
    private let progressBarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progress3")
        return imageView
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        label.text = "성별을 알려주세요."
        return label
    }()
    
    private let femaleButton: UIButton = {
        let button = UIButton()
        button.setTitle("여성", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.setTitleColor(UIColor(hex: "#616161"), for: .normal)
        button.backgroundColor = UIColor(hex: "#F2F2F2")
        button.layer.cornerRadius = 18.5
        button.isSelected = false
        
        button.addTarget(self, action: #selector(genderSelectOption), for: .touchUpInside)
        return button
    }()
    
    private let maleButton: UIButton = {
        let button = UIButton()
        button.setTitle("남성", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.setTitleColor(UIColor(hex: "#616161"), for: .normal)
        button.backgroundColor = UIColor(hex: "#F2F2F2")
        button.layer.cornerRadius = 18.5
        button.isSelected = false
        
        button.addTarget(self, action: #selector(genderSelectOption), for: .touchUpInside)
        return button
    }()
    
    private let birthLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        label.text = "출생년도를 알려주세요."
        return label
    }()
    
    private let birthDisplayTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.backgroundColor = UIColor(hex: "#F2F2F2")
        return textField
    }()
    
    private let birthNoticeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = UIColor(hex: "#6C6C70")
        label.text = "출생년도는 프로필에 공개되지 않습니다.\n프로필에 다음과 같이 표기될 목적으로 수집합니다.\n(예 - 10대, 20대, 30대 등)"
        return label
    }()
    
    private let nextButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("다음으로", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private func createBirthYearPicker() {
        let yearPicker = UIPickerView()
        yearPicker.dataSource = self
        yearPicker.delegate = self
        yearPicker.backgroundColor = .systemBackground
        yearPicker.selectRow(50, inComponent: 0, animated: true)
        birthDisplayTextField.inputView = yearPicker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureUI()
        configureTextField()
        setupLayout()
        createBirthYearPicker()
        hideKeyboardWhenTappedAround()
    }
    
    public func configureNavBar() {
        navigationItem.title = "프로필 설정"
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func configureTextField() {
        birthDisplayTextField.delegate = self
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(progressBarImageView, genderLabel, femaleButton, maleButton,
                         birthLabel, birthDisplayTextField, birthNoticeLabel, nextButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            progressBarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 1/10),
            progressBarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBarImageView.widthAnchor.constraint(equalToConstant: 186),
            progressBarImageView.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            genderLabel.topAnchor.constraint(equalTo: progressBarImageView.bottomAnchor, constant: 43),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            femaleButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 15),
            femaleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            femaleButton.widthAnchor.constraint(equalToConstant: 76),
            femaleButton.heightAnchor.constraint(equalToConstant: 37)
        ])
        
        NSLayoutConstraint.activate([
            maleButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 15),
            maleButton.leadingAnchor.constraint(equalTo: femaleButton.trailingAnchor, constant: 12),
            maleButton.widthAnchor.constraint(equalToConstant: 76),
            maleButton.heightAnchor.constraint(equalToConstant: 37)
        ])
        
        NSLayoutConstraint.activate([
            birthLabel.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: 77),
            birthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            birthDisplayTextField.topAnchor.constraint(equalTo: birthLabel.bottomAnchor, constant: 11),
            birthDisplayTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            birthDisplayTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            birthDisplayTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            birthNoticeLabel.topAnchor.constraint(equalTo: birthDisplayTextField.bottomAnchor, constant: 10),
            birthNoticeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            birthNoticeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: birthDisplayTextField.inputView?.topAnchor ?? view.bottomAnchor, constant: -(view.frame.height * 1/25))
        ])
    }
    
    @objc
    func genderSelectOption(_ sender: UIButton) {
        if femaleButton == sender {
            selectedButtonUI(femaleButton)
            unSelectedButtonUI(maleButton)
        } else {
            selectedButtonUI(maleButton)
            unSelectedButtonUI(femaleButton)
        }
        nextButtonActive()
    }
    
    func selectedButtonUI(_ sender: UIButton) {
        sender.isSelected = true
        sender.backgroundColor = UIColor(hex: "#333333")
        sender.setTitleColor(UIColor.white, for: .normal)
    }
    
    func unSelectedButtonUI(_ sender: UIButton) {
        sender.isSelected = false
        sender.backgroundColor = UIColor(hex: "#F2F2F2")
        sender.setTitleColor(UIColor(hex: "#616161"), for: .normal)
    }
    
    private func nextButtonActive() {
        if !(birthDisplayTextField.text == "") && (femaleButton.isSelected || maleButton.isSelected) {
            nextButton.isEnabled = true
            nextButton.setTitleColor(UIColor.label, for: .normal)
            nextButton.setBackgroundColor(UIColor(hex: "#FFD243"), for: .normal)
        }
    }
    
    private func nextButtonTapped() {
        //TODO: 프로필 설정 4번째 뷰(채식 단계 설정, 한줄 소개)로 연결
    }
}

extension UserGenderBirthViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 83
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1940)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        birthDisplayTextField.text = "  \(row+1940)"
    }
    
    
    
}

//출생년도 textField 수동 입력이 불가능하도록 설정
extension UserGenderBirthViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        
        if text.count <= 6 {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nextButtonActive()
    }
}
