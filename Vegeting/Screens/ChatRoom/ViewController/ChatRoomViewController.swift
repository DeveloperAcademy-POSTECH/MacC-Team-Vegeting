//
//  ChatRoomViewController.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/12.
//

import Combine
import UIKit

class ChatRoomViewController: UIViewController {
    
    private let vm = ChatRoomViewModel()
    
    private var input: PassthroughSubject<ChatRoomViewModel.Input, Never> = .init()
    private var messages: [Message] = []
    private var cancellables =  Set<AnyCancellable>()
    
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
        collectionView.register(OtherChatContentCollectionViewCell.self, forCellWithReuseIdentifier: OtherChatContentCollectionViewCell.identifier)
        collectionView.register(MyChatContentCollectionViewCell.self, forCellWithReuseIdentifier: MyChatContentCollectionViewCell.identifier)
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
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 22))
        let image = UIImage(systemName: "location", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
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
        bind()
        
    }
    
    
    private func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        
        output.sink { [weak self] event in
            switch event {
            case .localChatDataChanged(let messages), .serverChatDataChanged(let messages):
                self?.messages = messages
                DispatchQueue.main.async {
                    self?.chatListCollectionView.reloadData()
                }
            case .failToGetDataFromServer(let error):
                print(error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
    
    
    
}

// MARK: target-action 함수
extension ChatRoomViewController {
    @objc private func sendButtonTapped(_ sender: Any) {
        input.send(.sendButtonTapped(text: messageTextView.text))
        messageTextView.text = ""
    }
}

extension ChatRoomViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherChatContentCollectionViewCell.identifier, for: indexPath) as? OtherChatContentCollectionViewCell else { return UICollectionViewCell() }
        
        let data = messages[indexPath.row]
        cell.configure(with: data)
        return cell
    }
}

extension ChatRoomViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension ChatRoomViewController {
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
