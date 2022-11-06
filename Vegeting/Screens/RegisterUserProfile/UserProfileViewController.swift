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
        imageView.layer.cornerRadius = 55
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(hex: "#F2F2F2")
        return imageView
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        var image = UIImage(systemName: "camera.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(hex: "#373737")
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(presentPicker), for: .touchUpInside)
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
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음으로", for: .normal)
        button.setTitleColor(UIColor(hex: "#8E8E93"), for: .normal)
        button.setBackgroundColor(UIColor(hex: "#FFF6DA"), for: .normal)
        button.isEnabled = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureTextField()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupLayout()
    }
    
    func configureTextField() {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: nicknameTextField.frame.size.height-1, width: nicknameTextField.frame.width, height: 1)
        border.backgroundColor = UIColor(hex: "#F2F2F2").cgColor
        nicknameTextField.layer.addSublayer(border)
        nicknameTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeForLabel(_:)), name: UITextField.textDidChangeNotification, object: nicknameTextField)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(progressBarImageView, profileMessageLabel, profileImageView, nicknameMessageLabel, cameraButton, nicknameTextField, nicknameLimitWarningLabel, nextButton)
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            progressBarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 116),
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
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc
    private func presentPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc
    private func textDidChangeForLabel(_ notification: Notification) {
        if let nicknameTextField = notification.object as? UITextField {
            if let text = nicknameTextField.text {
                if text.count > nicknameMaxLength {
                    nicknameTextField.resignFirstResponder()
                }
                
                if text.count >= nicknameMaxLength {
                    let index = text.index(text.startIndex, offsetBy: nicknameMaxLength)
                    let newString = text[text.startIndex..<index]
                    nicknameTextField.text = String(newString)
                }
                else if text.count < nicknameMinLength {
                    nicknameLimitWarningLabel.text = "2글자 이상 10글자 이하로 입력해주세요"
                    nicknameLimitWarningLabel.textColor = .red
                } else {
                    nicknameLimitWarningLabel.text = "사용 가능한 닉네임입니다."
                    nicknameLimitWarningLabel.textColor = .blue
                    
                    nextButton.isEnabled = true
                    nextButton.setTitleColor(UIColor.label, for: .normal)
                    nextButton.setBackgroundColor(UIColor(hex: "#FFD243"), for: .normal)
                }
            }
        }
    }
    
    @objc
    private func textDidChangeForButton(_ textField: UITextField) {
        if nicknameTextField.hasText {
            //            if nextButton.isHighlighted
        }
    }
}

extension UserProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false}
        
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
                DispatchQueue.main.async {
                    self.profileImageView.image = image as? UIImage
                }
            }
        }
    }
}
