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
        var pickerView = PhotoPickerView()
        pickerView.setLabelText(text: StringLiteral.secondCreateGroupViewControllerPhoto)
        return pickerView
    }()
    
    private lazy var groupInfoStackView: GroupInfoView = {
        var stackView = GroupInfoView()
        return stackView
    }()
    
    private lazy var titleTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = StringLiteral.secondCreateGroupViewControllerTitle
        textField.font = .preferredFont(forTextStyle: .body)
        textField.layer.cornerRadius = 5
        textField.layer.backgroundColor = UIColor.systemGray4.cgColor
        textField.addLeftPadding()
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
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
    
    private lazy var contentTextview: UITextView = {
        var textView = UITextView()
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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupLayout() {
        view.addSubviews(coverPickerView, groupInfoStackView, titleTextField, titleWordsCountLabel,
                         contentTextview, contentWordsCountLabel, registerButton)
        
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
            contentTextview.topAnchor.constraint(equalTo: titleWordsCountLabel.bottomAnchor, constant: 30),
            contentTextview.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            contentTextview.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            contentTextview.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            contentWordsCountLabel.topAnchor.constraint(equalTo: contentTextview.bottomAnchor, constant: 8),
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhotoPicker(sender:)))
        coverPickerView.addGestureRecognizer(tapGesture)
        titleTextField.delegate = self
    }
    
    @objc
    private func tapPhotoPicker(sender: UITapGestureRecognizer) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let PHPicker = PHPickerViewController(configuration: configuration)
        PHPicker.delegate = self
        present(PHPicker, animated: true, completion: nil)
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
              let isContentTextEmpty = contentTextview.text?.isEmpty else { return }
        let isContentPlaceholer = contentTextview.text == StringLiteral.secondCreateGroupViewControllerContent
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

extension SecondCreateGroupViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    guard let image = image as? UIImage else { return }
                    self.coverPickerView.setImageView(image: image)
                    self.coverPickerView.setLabelText(text: "")
                }
            }
        }
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


