//
//  ReportTableViewCell.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/17.
//

import UIKit

protocol ReportTableViewCellDelegate: AnyObject {
    func requestUpdate()
}

final class ReportTableViewCell: UITableViewCell {
    
    // MARK: - properties
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    private let reportLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var contentTextView: UITextView = {
        var textView = UITextView()
        textView.text = StringLiteral.reportTableViewCellTextViewPlaceholder
        textView.textColor = .lightGray
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.cornerRadius = 5
        textView.layer.backgroundColor = UIColor.vfGray4.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 16.0, left: 10.0, bottom: 16.0, right: 10.0)
        //        textView.isHidden = true
        textView.delegate = self
        return textView
    }()
    
    private lazy var contentWordsCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "0/300"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .lightGray
        label.textAlignment = .right
        //        label.isHidden = true
        return label
    }()
    
    weak var delegate: ReportTableViewCellDelegate?
     
    // MARK: - lifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    func setupLayout(isOtherOption: Bool) {
        //        let isOtherOption = reportLabel.text == "기타 (직접 입력)"
        contentView.addSubviews(checkButton, reportLabel)
        checkButton.constraint(top: contentView.topAnchor,
                               leading: contentView.leadingAnchor,
                               bottom: isOtherOption ? nil : contentView.bottomAnchor,
                               padding: UIEdgeInsets(top: 10.5, left: 22, bottom: 10.5, right: 0))
        checkButton.constraint(.widthAnchor, constant: 22)
        checkButton.constraint(.heightAnchor, constant: 22)
        
        reportLabel.constraint(top: contentView.topAnchor,
                               leading: checkButton.trailingAnchor,
                               bottom: isOtherOption ? nil : contentView.bottomAnchor,
                               trailing: contentView.trailingAnchor,
                               padding: UIEdgeInsets(top: 10.5, left: 18, bottom: 10.5, right: 22))
        if isOtherOption {
            setupLayoutTextView()
        }
        contentTextView.isHidden = true
        contentWordsCountLabel.isHidden = true
    }
    
    func configure(with reportText: String) {
        reportLabel.text = reportText
        DispatchQueue.main.async { [weak self] in
            //            self?.setupLayout()
        }
    }
    
    private func setupLayoutTextView() {
        contentView.addSubviews(contentTextView, contentWordsCountLabel)
        contentTextView.constraint(top: reportLabel.bottomAnchor,
                                   leading: checkButton.trailingAnchor,
                                   trailing: contentView.trailingAnchor,
                                   padding: UIEdgeInsets(top: 14, left: 14, bottom: 0, right: 20))
        contentTextView.constraint(.heightAnchor, constant: 95)
        
        contentWordsCountLabel.constraint(top: contentTextView.bottomAnchor,
                                          bottom: contentView.bottomAnchor,
                                          trailing: contentView.trailingAnchor,
                                          padding: UIEdgeInsets(top: 4, left: 0, bottom: 10.5, right: 20))
    }
    
    @objc
    private func checkButtonTapped() {
        checkButton.isSelected.toggle()
        if reportLabel.text == "기타 (직접 입력)" {
            contentTextView.isHidden.toggle()
            contentWordsCountLabel.isHidden.toggle()
//            contentTextView.removeFromSuperview()
//            contentTextView.removeFromSuperview()
//            delegate?.requestUpdate()
        }
    }
    
    private func updateContentCountLabel(characterCount: Int) {
        contentWordsCountLabel.text = "\(characterCount)/300"
    }
    
}

extension ReportTableViewCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == StringLiteral.reportTableViewCellTextViewPlaceholder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = StringLiteral.reportTableViewCellTextViewPlaceholder
            textView.textColor = .lightGray
        } else {
            if textView.text.count > 300 {
                textView.text.removeLast()
                updateContentCountLabel(characterCount: 300)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textWithoutWhiteSpace = text.trimmingCharacters(in: .whitespaces)
        let newLength = textView.text.count - range.length + textWithoutWhiteSpace.count
        let contentMaxCount = 300
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
