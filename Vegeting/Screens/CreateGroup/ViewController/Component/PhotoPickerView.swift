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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .vfGray1
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .vfGray1
        return label
    }()
    
    private lazy var cameraButton: UIButton = {
       let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration.init(pointSize: 40, weight: .regular)
        button.setImage(UIImage(systemName: "camera.circle.fill", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(tapPhotoPicker(sender:)), for: .touchUpInside)
        return button
    }()
    
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
        backgroundColor = .vfGray4
        clipsToBounds = true
        selectedImage.contentMode = .scaleAspectFill
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhotoPicker(sender:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func setupLayout() {
        addSubviews(selectedImage, titleLabel, subTitleLabel, cameraButton)
        selectedImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedImage.topAnchor.constraint(equalTo: self.topAnchor),
            selectedImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            selectedImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            selectedImage.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -3),
            titleLabel.trailingAnchor.constraint(equalTo: cameraButton.leadingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            subTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -19)
        ])
        
        NSLayoutConstraint.activate([
            cameraButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            cameraButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -19),
            cameraButton.widthAnchor.constraint(equalToConstant: 40),
            cameraButton.heightAnchor.constraint(equalToConstant: 40)
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
            self.setLabelText(title: "", sub: "")
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
    
    func setLabelText(title: String, sub: String) {
        titleLabel.text = title
        subTitleLabel.text = sub
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
                    self.setLabelText(title: "", sub: "")
                    self.isDefaultImage = false
                }
            }
        }
    }
}
