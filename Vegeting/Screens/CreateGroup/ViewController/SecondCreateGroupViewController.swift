//
//  SecondCreateGroupViewController.swift
//  Vegeting
//
//  Created by kelly on 2022/10/24.
//

import UIKit
import PhotosUI

final class SecondCreateGroupViewController: BaseViewController {
    private lazy var coverPickerView: PhotoPickerView = {
        let pickerView = PhotoPickerView()
        pickerView.setLabelText(text: StringLiteral.secondCreateGroupViewControllerPhoto)
        pickerView.delegate = self
        return pickerView
    }()
    
    private lazy var groupInfoStackView: GroupInfoView = {
        let stackView = GroupInfoView()
        return stackView
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = StringLiteral.secondCreateGroupViewControllerTitle
        textField.font = .preferredFont(forTextStyle: .body)
        textField.layer.cornerRadius = 5
        textField.layer.backgroundColor = UIColor.systemGray4.cgColor
        textField.addLeftPadding()
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var titleWordsCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "0/20"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = StringLiteral.secondCreateGroupViewControllerContent
        textView.textColor = .lightGray
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.cornerRadius = 5
        textView.layer.backgroundColor = UIColor.systemGray4.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 16.0, left: 10.0, bottom: 16.0, right: 10.0)
        textView.delegate = self
        return textView
    }()
    
    private lazy var contentWordsCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "0/500"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    private lazy var registerButton: BottomButton = {
        let button = BottomButton()
        button.isEnabled = false
        button.setTitle(StringLiteral.secondCreateGroupViewControllerRegisterButton, for: .normal)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - func
    
    override func setupLayout() {
        view.addSubviews(coverPickerView, groupInfoStackView, titleTextField, titleWordsCountLabel,
                         contentTextView, contentWordsCountLabel, registerButton)
        
        NSLayoutConstraint.activate([
            coverPickerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            coverPickerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            coverPickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            coverPickerView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            groupInfoStackView.topAnchor.constraint(equalTo: coverPickerView.bottomAnchor, constant: 30),
            groupInfoStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32),
            groupInfoStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            groupInfoStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: groupInfoStackView.bottomAnchor, constant: 30),
            titleTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            titleTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            titleWordsCountLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            titleWordsCountLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            titleWordsCountLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: titleWordsCountLabel.bottomAnchor, constant: 30),
            contentTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            contentTextView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            contentTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            contentWordsCountLabel.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 8),
            contentWordsCountLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            contentWordsCountLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            registerButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            registerButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
        ])
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    @objc
    private func registerButtonTapped() {
        guard var club = makeClub(),
              let chat = makeChat() else { return }
        
        getImageURL() { url in
            club.coverImageURL = url
            Task {
                guard let vfUser = await FirebaseManager.shared.requestUser() else { return }
                FirebaseManager.shared.requestPost(user: vfUser, club: club, chat: chat)
            }
        }
        
        navigationController?.popToRootViewController(animated: true)
    }

    private func getImageURL(completion: @escaping (URL?) -> Void) {
        if !coverPickerView.isDefaultImage {
            guard let image = coverPickerView.getImageView() else { return completion(nil) }
            FirebaseStorageManager.uploadImage(image: image, folderName: "club") { url in
                guard let url = url else {return}
                completion(url)
            }
        } else {
            completion(nil)
        }
    }
    
    private func makeClub() -> Club? {
        guard let incompleteClub = groupInfoStackView.getData(),
              let clubTitle = titleTextField.text else { return nil }
        let club = Club(id: nil, clubID: nil, chatID: nil,
                        clubTitle: clubTitle,
                        clubCategory: incompleteClub.clubCategory,
                        clubContent: contentTextView.text,
                        hostID: nil, participants: nil,
                        dateToMeet: incompleteClub.dateToMeet,
                        createdAt: Date(),
                        placeToMeet: incompleteClub.placeToMeet,
                        maxNumberOfPeople: incompleteClub.maxNumberOfPeople)
        return club
    }
    
    private func makeChat() -> Chat? {
        guard let clubTitle = titleTextField.text else { return nil }
        let chat = Chat(chatRoomID: nil,
                        clubID: nil,
                        chatRoomName: clubTitle,
                        participants: nil,
                        messages: nil,
                        coverImageURL: nil)
        return chat
    }
    
    @objc
    private func didTextFieldChanged() {
        checkRegisterButtonEnabled()
    }
    
    private func updateTitleCountLabel(characterCount: Int) {
        titleWordsCountLabel.text = "\(characterCount)/20"
    }
    
    private func updateContentCountLabel(characterCount: Int) {
        contentWordsCountLabel.text = "\(characterCount)/500"
    }
    
    private func checkRegisterButtonEnabled() {
        guard let isTitleEmpty = titleTextField.text?.isEmpty,
              let isContentTextEmpty = contentTextView.text?.isEmpty else { return }
        let isContentPlaceholer = contentTextView.text == StringLiteral.secondCreateGroupViewControllerContent
        let isContentEmpty = isContentTextEmpty || isContentPlaceholer
        
        if !isTitleEmpty && !isContentEmpty {
            registerButton.isEnabled = true
        } else {
            registerButton.isEnabled = false
        }
    }
    
    func configure(with data: IncompleteClub) {
        groupInfoStackView.configure(with: data)
    }
}

extension SecondCreateGroupViewController: PhotoPickerViewDelegate {
    func showPHPicker(PHPicker: PHPickerViewController) {
        present(PHPicker, animated: true, completion: nil)
    }
    
    func showActionSheet(actionSheet: UIAlertController) {
        present(actionSheet, animated: true, completion: nil)
    }
}

extension SecondCreateGroupViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        checkRegisterButtonEnabled()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == StringLiteral.secondCreateGroupViewControllerContent {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = StringLiteral.secondCreateGroupViewControllerContent
            textView.textColor = .lightGray
        } else {
            if textView.text.count > 500 {
                textView.text.removeLast()
                updateContentCountLabel(characterCount: 500)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textWithoutWhiteSpace = text.trimmingCharacters(in: .whitespaces)
        let newLength = textView.text.count - range.length + textWithoutWhiteSpace.count
        let contentMaxCount = 500
        if newLength > contentMaxCount + 1 {
            let overflow = newLength - (contentMaxCount + 1)
            let index = textWithoutWhiteSpace.index(textWithoutWhiteSpace.endIndex, offsetBy: -overflow)
            let newText = textWithoutWhiteSpace[..<index]
            guard let startPosition = textView.position(from: textView.beginningOfDocument, offset: range.location) else { return false }
            guard let endPosition = textView.position(from: textView.beginningOfDocument, offset: NSMaxRange(range)) else { return false }
            guard let textRange = textView.textRange(from: startPosition, to: endPosition) else { return false }
            textView.replace(textRange, withText: String(newText))
            if textView.text.count > contentMaxCount {
                textView.text.removeLast()
            }
            updateContentCountLabel(characterCount: contentMaxCount)
            return false
        } else {
            updateContentCountLabel(characterCount: newLength)
            return true
        }
    }
}

extension SecondCreateGroupViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let count = textField.text?.count  else { return }
        if count > 20 {
            textField.text?.removeLast()
            updateTitleCountLabel(characterCount: 20)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textWithoutWhiteSpace = string.trimmingCharacters(in: .whitespaces)
        let newLength = (textField.text?.count ?? 0) - range.length + textWithoutWhiteSpace.count
        let titleMaxCount = 20
        if newLength > titleMaxCount + 1 {
            let overflow = newLength - (titleMaxCount + 1)
            let index = textWithoutWhiteSpace.index(textWithoutWhiteSpace.endIndex, offsetBy: -overflow)
            let newText = textWithoutWhiteSpace[..<index]
            guard let startPosition = textField.position(from: textField.beginningOfDocument, offset: range.location) else { return false }
            guard let endPosition = textField.position(from: textField.beginningOfDocument, offset: NSMaxRange(range)) else { return false }
            guard let textRange = textField.textRange(from: startPosition, to: endPosition) else { return false }
            textField.replace(textRange, withText: String(newText))
            if textField.text?.count ?? 0 > titleMaxCount {
                textField.text?.removeLast()
            }
            updateTitleCountLabel(characterCount: titleMaxCount)
            return false
        } else {
            updateTitleCountLabel(characterCount: newLength)
            return true
        }
    }
}


