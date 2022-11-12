//
//  ChatRoomViewController.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/12.
//

import UIKit

class ChatRoomViewController: UIViewController {

    private let chatListCollectionView: UICollectionView = {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(20)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
    
        let layout = UICollectionViewCompositionalLayout(section: section)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChatRoomContentCollectionViewCell.self, forCellWithReuseIdentifier: ChatRoomContentCollectionViewCell.identifier)
        return collectionView
    }()

    private let transferMessageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()

    private let plusButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 22))
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        return button
    }()

    private let sendButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 22))
        let image = UIImage(systemName: "location", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        return button
    }()


    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .gray.withAlphaComponent(0.1)
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 13
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 16)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupLayout()
    }


    private func configureUI() {
        view.addSubviews(chatListCollectionView,transferMessageStackView)
        view.backgroundColor = .systemBackground

        chatListCollectionView.dataSource = self
        chatListCollectionView.delegate = self
    }

    private func setupLayout() {

        transferMessageStackView.addArrangedSubviews(plusButton, messageTextView, sendButton)

        messageTextView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        let transferMessageStackViewConstraints = [
            transferMessageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transferMessageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            transferMessageStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -12)
        ]


        let chatListCollectionViewConstraints = [
            chatListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatListCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            chatListCollectionView.bottomAnchor.constraint(equalTo: transferMessageStackView.topAnchor, constant: -20)
        ]

        constraintsActivate(transferMessageStackViewConstraints, chatListCollectionViewConstraints)
    }

}

extension ChatRoomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatRoomContentCollectionViewCell.identifier, for: indexPath) as? ChatRoomContentCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setRandomLabel()
        return cell
    }
}

extension ChatRoomViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}
