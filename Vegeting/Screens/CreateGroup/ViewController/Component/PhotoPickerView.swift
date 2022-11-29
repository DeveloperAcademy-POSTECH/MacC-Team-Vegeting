//
//  PhotoPickerView.swift
//  Vegeting
//
//  Created by kelly on 2022/10/24.
//

import UIKit
import PhotosUI

protocol PhotoPickerViewDelegate: AnyObject {
    func showPHPicker(PHPicker: PHPickerViewController)
    func showActionSheet(actionSheet: UIAlertController)
}

final class PhotoPickerView: UIView {
    private var isDefaultImage = true
    private let selectedImage = UIImageView()
    private let label = UILabel()
    weak var delegate: PhotoPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .systemGray4
        clipsToBounds = true
        selectedImage.contentMode = .scaleAspectFill
        label.textColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhotoPicker(sender:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func setupLayout() {
        addSubview(selectedImage)
        selectedImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedImage.topAnchor.constraint(equalTo: self.topAnchor),
            selectedImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            selectedImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            selectedImage.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    @objc
    private func tapPhotoPicker(sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        
        let albumAction = UIAlertAction(title: "앨범에서 사진 선택", style: .default) { action in
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            let PHPicker = PHPickerViewController(configuration: configuration)
            PHPicker.delegate = self
            self.delegate?.showPHPicker(PHPicker: PHPicker)
        }
        
        let defaultImageAction = UIAlertAction(title: "기본 이미지로 변경", style: .default) { action in
            self.setImageView(image: UIImage(named: "coverImage")) // 추후 기본이미지로 변경
            self.isDefaultImage = true
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [albumAction, defaultImageAction, cancelAction].forEach { action in
            actionSheet.addAction(action)
        }
        
        self.delegate?.showActionSheet(actionSheet: actionSheet)
    }

    func setImageView(image: UIImage?) {
        selectedImage.image = image
    }
    
    func getImageView() -> UIImage? {
        return selectedImage.image
    }
    
    func setLabelText(text: String) {
        label.text = text
    }
    
    func isDefaultCoverImage() -> Bool {
        return self.isDefaultImage
    }
}

extension PhotoPickerView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    guard let image = image as? UIImage else { return }
                    self.setImageView(image: image)
                    self.setLabelText(text: "")
                    self.isDefaultImage = false
                }
            }
        }
    }
}
