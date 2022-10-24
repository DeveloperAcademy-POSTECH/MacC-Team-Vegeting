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
