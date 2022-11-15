//
//  UserProfileViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/02.
//

import UIKit
import PhotosUI

final class UserProfileViewController: UIViewController {
    
    private let nicknameMinLength = 2
    private let nicknameMaxLength = 10
    
    private let progressBarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progress1")
        return imageView
    }()
    
    private let profileMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 사진을 선택해주세요."
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 55
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(hex: "#F2F2F2")
        return imageView
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        var image = UIImage(systemName: "camera.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(hex: "#373737")
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nicknameMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 입력해주세요."
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        return textField
    }()
    
    private lazy var nicknameLimitWarningLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let nextButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("다음으로", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureTextField()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureUI()
        setupLayout()
        hideKeyboardWhenTappedAround()
    }
    
    func configureNavBar() {
        navigationItem.title = "프로필 설정"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func configureTextField() {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: nicknameTextField.frame.size.height-1,
                              width: nicknameTextField.frame.width, height: 1)
        border.backgroundColor = UIColor(hex: "#F2F2F2").cgColor
        nicknameTextField.layer.addSublayer(border)
        nicknameTextField.delegate = self
        
        nicknameTextField.addTarget(self, action: #selector(textDidChangeForLabel), for: .editingChanged)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(progressBarImageView, profileMessageLabel, profileImageView,
                         nicknameMessageLabel, cameraButton, nicknameTextField,
                         nicknameLimitWarningLabel, nextButton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            progressBarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 1/10),
            progressBarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBarImageView.widthAnchor.constraint(equalToConstant: 186),
            progressBarImageView.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            profileMessageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 178),
            profileMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21)
        ])
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: profileMessageLabel.bottomAnchor, constant: 17),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 110),
            profileImageView.widthAnchor.constraint(equalToConstant: 110)
        ])
        
        NSLayoutConstraint.activate([
            cameraButton.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 78),
            cameraButton.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 78),
            cameraButton.widthAnchor.constraint(equalToConstant: 30),
            cameraButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            nicknameMessageLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 78),
            nicknameMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21)
        ])
        
        NSLayoutConstraint.activate([
            nicknameTextField.topAnchor.constraint(equalTo: nicknameMessageLabel.bottomAnchor, constant: 17),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nicknameTextField.widthAnchor.constraint(equalToConstant: 350),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            nicknameLimitWarningLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 13),
            nicknameLimitWarningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height * 1/25))
        ])
    }
    
    @objc
    private func cameraButtonTapped() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc
    private func textDidChangeForLabel() {
        guard let text = nicknameTextField.text else { return }
        
        //maxLength 초과 시 키보드를 아래로 내려주는 역할
        if text.count >= nicknameMaxLength {
            nicknameTextField.resignFirstResponder()
        }
        
        if text.count > nicknameMaxLength {
            let index = text.index(text.startIndex, offsetBy: nicknameMaxLength)
            let newString = text[text.startIndex..<index]
            nicknameTextField.text = String(newString)
        } else if text.count < nicknameMinLength {
            nicknameLimitWarningLabel.text = "2글자 이상 10글자 이하로 입력해주세요"
            nicknameLimitWarningLabel.textColor = .red
            nextButtonInactive()
        } else {
            nicknameLimitWarningLabel.text = "사용 가능한 닉네임입니다."
            nicknameLimitWarningLabel.textColor = .blue
            
            nextButtonActive()
        }
    }
    
    private func nextButtonInactive() {
        nextButton.isEnabled = false
    }
    
    private func nextButtonActive() {
        nextButton.isEnabled = true
        nextButton.setTitleColor(UIColor.label, for: .normal)
        nextButton.setBackgroundColor(UIColor(hex: "#FFD243"), for: .normal)
    }
    
    @objc
    private func nextButtonTapped() {
        navigationController?.pushViewController(LocationAuthViewController(), animated: true)
    }
}

extension UserProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count >= nicknameMaxLength && range.length == 0 && range.location < nicknameMaxLength {
            return false
        }
        return true
    }
}

extension UserProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async { [weak self] in
                    self?.profileImageView.image = image as? UIImage
                }
            }
        }
    }
}
