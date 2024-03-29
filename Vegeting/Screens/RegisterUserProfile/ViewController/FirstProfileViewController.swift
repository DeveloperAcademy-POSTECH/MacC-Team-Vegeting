//
//  UserProfileViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/02.
//

import UIKit
import PhotosUI

final class FirstProfileViewController: UIViewController {
    
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
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 55
        imageView.clipsToBounds = true
        imageView.backgroundColor = .vfGray4
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped)))
        imageView.isUserInteractionEnabled = true
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
        button.addTarget(self, action: #selector(cameraButtontapped), for: .touchUpInside)
        return button
    }()
    
    private let nicknameMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 입력해주세요."
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.delegate = self
        textField.clearButtonMode = .always
        textField.addTarget(self, action: #selector(textDidChangeForLabel), for: .editingChanged)
        return textField
    }()
    
    private let validImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let validLabel: UILabel = {
        let label  = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let nicknameTextCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .vfGray3
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = "0/10"
        return label
    }()
    
    private let nextButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("다음으로", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nicknameTextField.underlined(color: .vfGray4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
        setupLayout()
        hideKeyboardWhenTappedAround()
    }
    
    func configureNavBar() {
        self.navigationItem.title = "프로필 설정"
        navigationController?.navigationBar.tintColor = .label
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(progressBarImageView, profileMessageLabel, profileImageView,
                         nicknameMessageLabel, cameraButton, nicknameTextField,
                         validImageView, validLabel, nicknameTextCountLabel, nextButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            progressBarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 1/10),
            progressBarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBarImageView.widthAnchor.constraint(equalToConstant: 186),
            progressBarImageView.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            profileMessageLabel.topAnchor.constraint(equalTo: progressBarImageView.bottomAnchor, constant: view.frame.height * 1/10),
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
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            validImageView.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 10),
            validImageView.leadingAnchor.constraint(equalTo: nicknameTextField.leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            validLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 10),
            validLabel.leadingAnchor.constraint(equalTo: nicknameTextField.leadingAnchor, constant: 15),
        ])
        
        NSLayoutConstraint.activate([
            nicknameTextCountLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 10),
            nicknameTextCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height * 1/25))
        ])
    }
    
    @objc
    private func profileImageViewTapped() {
        presentPHPicker()
    }
    
    @objc
    private func cameraButtontapped() {
        presentPHPicker()
    }
    
    private func presentPHPicker() {
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
        var textLength = text.count
        
        //maxLength 초과 시 키보드를 아래로 내려주는 역할
        if textLength >= nicknameMaxLength {
            nicknameTextField.resignFirstResponder()
        }
        
        //maxLength 이상의 글자를 붙여넣을 경우 잘라주는 역할
        if textLength > nicknameMaxLength {
            let index = text.index(text.startIndex, offsetBy: nicknameMaxLength)
            let newString = text[text.startIndex..<index]
            nicknameTextField.text = String(newString)
            textLength = newString.count
        } else if textLength < nicknameMinLength {
            nextButtonInactive()
        } else {
            nextButtonActive()
        }
        
        validateNickname()
        configureTextCountLabel(textLength: textLength)
    }
    
    private func validateNickname() {
        guard let nickname = nicknameTextField.text else { return }

        if nickname.count < 2 {
            changeButtonStatusAndValidLabel(false, text: " 닉네임은 두 글자 이상이어야 합니다.")
        } else {
            Task { [weak self] in
                let isPossible = try await FirebaseManager.shared.isPossibleNickname(newName: nickname)
                self?.changeButtonStatusAndValidLabel(isPossible, text: (isPossible ? " 사용 가능한 닉네임입니다." : " 다른 사용자가 사용 중인 닉네임입니다."))
            }
        }
    }
    
    private func changeButtonStatusAndValidLabel(_ isPossible: Bool, text: String) {
        let imageSize = CGSize(width: 15, height: 15)
        let textColor = isPossible ? UIColor.vfGreen : UIColor.vfRed
        
        validImageView.image = UIImage(systemName: (isPossible ? "checkmark.circle.fill" : "exclamationmark.circle.fill"))?.withTintColor(textColor).resize(to: imageSize)
    
        validLabel.text = text
        validLabel.textColor = textColor
        
        nextButton.isEnabled = isPossible
    }
    
    private func configureTextCountLabel(textLength: Int) {
        nicknameTextCountLabel.text = "\(textLength)/\(nicknameMaxLength)"
    }
    
    private func nextButtonInactive() {
        nextButton.isEnabled = false
    }
    
    private func nextButtonActive() {
        nextButton.isEnabled = true
    }
    
    @objc
    private func nextButtonTapped() {
        nextButtonInactive()
        guard let nickname = nicknameTextField.text else {
            return
        }
        
        requestImageURL { url in
            let profileImage = url
            let userImageNickname = FirstImageNickname(userImageURL: profileImage, userNickname: nickname)
            self.navigationController?.pushViewController(SecondLocationViewController(userImageNickname: userImageNickname), animated: true)
            self.nextButtonActive()
        }
    }
    
    private func requestImageURL(completion: @escaping (URL?) -> Void) {
        if profileImageView.image == nil {
            profileImageView.setRandomProfile()
        }
        
        guard let image = profileImageView.image else {
            completion(nil)
            return
        }
        FirebaseStorageManager.shared.uploadImage(image: image, folderName: "userProfile") { result in
            switch result {
            case .success(let url):
                completion(url)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension FirstProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count >= nicknameMaxLength && range.length == 0 && range.location < nicknameMaxLength {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.underlined(color: .vfYellow1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.underlined(color: .vfGray4)
    }
}

extension FirstProfileViewController: PHPickerViewControllerDelegate {
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
