//
//  SecondCreateGroupViewController.swift
//  Vegeting
//
//  Created by kelly on 2022/10/24.
//

import UIKit
import PhotosUI

final class SecondCreateGroupViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var coverPickerView: PhotoPickerView = {
        var pickerView = PhotoPickerView()
        pickerView.setLabelText(title: "모임과 관련된 사진을 첨부해주세요.",
                                sub: "사진은 1장만 첨부할 수 있어요.")
        pickerView.delegate = self
        return pickerView
    }()
    
    private lazy var groupInfomationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .vfGray3
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = StringLiteral.secondCreateGroupViewControllerTitle
        textField.font = .preferredFont(forTextStyle: .body)
        textField.layer.cornerRadius = 5
        textField.layer.backgroundColor = UIColor.vfGray4.cgColor
        textField.addLeftPadding(width: 10)
        textField.addRightPadding(width: 40)
        textField.placeholder = "제목을 입력해주세요. (최대 20자)"
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .vfYellow2
        label.layer.cornerRadius = 15.5
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        label.textColor = .vfGray1
        label.textAlignment = .center
        label.layer.masksToBounds = true
        return label
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
        textView.layer.backgroundColor = UIColor.vfGray4.cgColor
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
        button.setTitle(createGroupEntryPoint == .create ? StringLiteral.secondCreateGroupViewControllerRegisterButton : "수정 완료", for: .normal)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var club: Club?
    private var incompleteClub: IncompleteClub?
    private var createGroupEntryPoint: CreateGroupEntryPoint
    
    //MARK: - lifeCycle
    
    init(club: Club? = nil, incompleteClub: IncompleteClub? = nil, createGroupEntryPoint: CreateGroupEntryPoint) {
        self.club = club
        self.incompleteClub = incompleteClub
        self.createGroupEntryPoint = createGroupEntryPoint
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardWillShow()
    }
    
    //MARK: - func
    
    override func setupLayout() {
        
        view.addSubviews(scrollView, registerButton)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(coverPickerView, categoryLabel, groupInfomationLabel,
                                titleTextField, titleWordsCountLabel, contentTextView, contentWordsCountLabel)
        
        scrollView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: registerButton.topAnchor,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              padding: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        
        contentView.constraint(top: scrollView.contentLayoutGuide.topAnchor,
                               leading: scrollView.contentLayoutGuide.leadingAnchor,
                               bottom: scrollView.contentLayoutGuide.bottomAnchor,
                               trailing: scrollView.contentLayoutGuide.trailingAnchor)
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            coverPickerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            coverPickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverPickerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            coverPickerView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.25)
        ])
        
        let width = (incompleteClub?.clubCategory.size(withAttributes: [.font : UIFont.preferredFont(forTextStyle: .subheadline)]).width ?? 0) + 40
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: coverPickerView.bottomAnchor, constant: 15),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryLabel.heightAnchor.constraint(equalToConstant: 31),
            categoryLabel.widthAnchor.constraint(equalToConstant: width)
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 15),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            groupInfomationLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 13),
            groupInfomationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            titleWordsCountLabel.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor, constant: -8),
            titleWordsCountLabel.centerYAnchor.constraint(equalTo: titleTextField.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: groupInfomationLabel.bottomAnchor, constant: 13),
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentTextView.heightAnchor.constraint(equalToConstant: 263),
            contentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            contentWordsCountLabel.bottomAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: -9),
            contentWordsCountLabel.trailingAnchor.constraint(equalTo: contentTextView.trailingAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -55)
        ])
    }

    @objc
    private func registerButtonTapped() {
        switch createGroupEntryPoint {
        case .create:
            self.registerClub()
        case .revise:
            self.updateClub()
        }
        navigationController?.popToRootViewController(animated: true)
    }

    private func registerClub() {
        guard var club = makeClub(),
              var chat = makeChat() else { return }

        requestImageURL() { url in
            club.coverImageURL = url
            chat.coverImageURL = url
            Task {
                guard let vfUser = AuthManager.shared.currentUser() else { return }
                FirebaseManager.shared.requestPost(user: vfUser, club: club, chat: chat)
            }
        }
    }
    
    private func updateClub() {
//        var club = Club(id: club.id,
//                               clubID: club.clubID,
//                               chatID: club.chatID,
//                               clubTitle: clubTitle,
//                               clubCategory: incompleteClub.clubCategory,
//                               clubContent: contentTextView.text,
//                               hostID: club.hostID,
//                               participants: club.participants,
//                               dateToMeet: incompleteClub.dateToMeet,
//                               createdAt: club.createdAt,
//                               placeToMeet: club.placeToMeet,
//                               maxNumberOfPeople: incompleteClub.maxNumberOfPeople,
//                               coverImageURL: <#T##URL?#>)
        // TODO: url로 넘기지 말고, UIimage로 넘겨서 image 변화여부를 체크하여 getImageURL을 호출해야할 것 같아요.
    }
    
    private func requestImageURL(completion: @escaping (URL?) -> Void) {
        if !coverPickerView.isDefaultCoverImage() {
            guard let image = coverPickerView.getImageView()
            else {
                completion(nil)
                return
            }
            FirebaseStorageManager.shared.uploadImage(image: image, folderName: "club") { result in
                switch result {
                case .success(let url):
                    completion(url)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    private func makeClub() -> Club? {
        guard let incompleteClub = incompleteClub,
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
    
    override func configureUI() {
        scrollView.showsVerticalScrollIndicator = false
        view.backgroundColor = .systemBackground
    }
    
    private func applyEditingTextViewForm() {
         contentTextView.backgroundColor = .systemBackground
         contentTextView.layer.borderColor = UIColor.vfYellow1.cgColor
         contentTextView.layer.borderWidth = 1.5
     }

     private func applyEndEditingTextViewForm() {
         contentTextView.backgroundColor = .vfGray4
         contentTextView.layer.borderColor = UIColor.vfYellow1.cgColor
         contentTextView.layer.borderWidth = 0
     }
    
    private func applyEditingTextFieldForm() {
        titleTextField.backgroundColor = .systemBackground
        titleTextField.layer.borderColor = UIColor.vfYellow1.cgColor
        titleTextField.layer.borderWidth = 1.5
    }

     private func applyEndEditingTextFieldForm() {
         titleTextField.backgroundColor = .vfGray4
         titleTextField.layer.borderColor = UIColor.vfYellow1.cgColor
         titleTextField.layer.borderWidth = 0
     }
    
    private func observeKeyboardWillShow() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollVerticalWhenKeybaordWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    @objc
    private func scrollVerticalWhenKeybaordWillShow(notification: NSNotification) {
        let scrollHeightToBottom = scrollView.contentSize.height - scrollView.bounds.size.height
        if scrollHeightToBottom > 0 {
            let scrollHeightToBottomOffset = CGPoint(x: 0, y: scrollHeightToBottom)
            scrollView.setContentOffset(scrollHeightToBottomOffset, animated: true)
        }
    }

    func configure(with data: IncompleteClub) {
        categoryLabel.text = data.clubCategory
        groupInfomationLabel.text = "\(data.placeToMeet)･\(data.dateToMeet.toString(format: "M월 d일"))"
    }
    
    func configure(with data: Club?) {
        guard let data = data else { return }
        titleTextField.text = data.clubTitle
        contentTextView.text = data.clubContent
        contentWordsCountLabel.text = "\(data.clubContent.count)/500"
        titleWordsCountLabel.text = "\(data.clubTitle.count)/20"
        
        registerButton.isEnabled = true
        contentTextView.textColor = .black
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
        applyEditingTextViewForm()
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
        applyEndEditingTextViewForm()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        applyEditingTextFieldForm()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let count = textField.text?.count  else { return }
        if count > 20 {
            textField.text?.removeLast()
            updateTitleCountLabel(characterCount: 20)
        }
        applyEndEditingTextFieldForm()
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


