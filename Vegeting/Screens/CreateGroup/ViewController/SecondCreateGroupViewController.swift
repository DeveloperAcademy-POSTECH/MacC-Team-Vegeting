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
    
    private lazy var contentTextview: UITextView = {
        var textView = UITextView()
        textView.layer.cornerRadius = 5
        textView.layer.backgroundColor = UIColor.systemGray4.cgColor
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
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
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhotoPicker(sender:)))
        coverPickerView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapPhotoPicker(sender: UITapGestureRecognizer) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let PHPicker = PHPickerViewController(configuration: configuration)
        PHPicker.delegate = self
        self.present(PHPicker, animated: true, completion: nil)
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
