//
//  SecondCreateGroupViewController.swift
//  Vegeting
//
//  Created by kelly on 2022/10/24.
//

import UIKit
import PhotosUI

class SecondCreateGroupViewController: UIViewController {
    private lazy var coverPickerView: PhotoPickerView = {
        var pickerView = PhotoPickerView()
        pickerView.label.text = "사진을 선택해주세요"
        return pickerView
    }()
    
    private lazy var titleTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "제목을 입력해주세요"
        textField.font = .preferredFont(forTextStyle: .body)
        textField.layer.cornerRadius = 5
        textField.layer.backgroundColor = UIColor.systemGray4.cgColor
        textField.addLeftPadding()
        return textField
    }()
    
    let textViewPlaceHolder = "모임의 상세정보를 설명해주세요"
    private lazy var contentTextview: UITextView = {
        var textView = UITextView()
        textView.text = textViewPlaceHolder
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupLayout()
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(coverPickerView)
        coverPickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverPickerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            coverPickerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            coverPickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            coverPickerView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: coverPickerView.bottomAnchor, constant: 30),
            titleTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            titleTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        view.addSubview(contentTextview)
        contentTextview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentTextview.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 30),
            contentTextview.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            contentTextview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            contentTextview.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        view.addSubview(contentWordsCountLabel)
        contentWordsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentWordsCountLabel.topAnchor.constraint(equalTo: contentTextview.bottomAnchor, constant: 8),
            contentWordsCountLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            contentWordsCountLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhotoPicker(sender:)))
        coverPickerView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func tapPhotoPicker(sender: UITapGestureRecognizer) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let PHPicker = PHPickerViewController(configuration: configuration)
        PHPicker.delegate = self
        self.present(PHPicker, animated: true, completion: nil)
    }
    
    private func updateCountLabel(characterCount: Int) {
        contentWordsCountLabel.text = "\(characterCount)/500"
    }
}

extension SecondCreateGroupViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    guard let image = image as? UIImage else { return }
                    self.coverPickerView.selectedImage.image = image
                    self.coverPickerView.label.text = ""
                }
            }
        }
    }
}

extension SecondCreateGroupViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        } else {
            if textView.text.count > 500 {
                textView.text.removeLast()
                updateCountLabel(characterCount: textView.text.count)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textWithoutWhiteSpace = text.trimmingCharacters(in: .whitespaces)
        var newLength = textView.text.count - range.length + textWithoutWhiteSpace.count
        let contentMaxCount = 500 + 1
        if newLength > contentMaxCount {
            let overflow = newLength - contentMaxCount
            let index = textWithoutWhiteSpace.index(textWithoutWhiteSpace.endIndex, offsetBy: -overflow)
            let newText = textWithoutWhiteSpace[..<index]
            guard let startPosition = textView.position(from: textView.beginningOfDocument, offset: range.location) else { return false }
            guard let endPosition = textView.position(from: textView.beginningOfDocument, offset: NSMaxRange(range)) else { return false }
            guard let textRange = textView.textRange(from: startPosition, to: endPosition) else { return false }
            textView.replace(textRange, withText: String(newText))
            if textView.text.count > 500 {
                textView.text.removeLast()
            }
            updateCountLabel(characterCount: 500)
            return false
        } else {
            if newLength == 501 {
                    newLength = 500
            }
            updateCountLabel(characterCount: newLength)
            return true
        }
    }
}
