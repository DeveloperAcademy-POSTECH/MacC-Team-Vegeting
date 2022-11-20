//
//  ChatRoomViewController.swift
//  Vegeting
//
//  Created by yudonlee on 2022/11/12.
//

import Combine
import UIKit


fileprivate enum keyboardHeightType: Int {
    case zeroNewLine = 0
    case oneNewLine = 1
    case twoNewLine = 2
    case other

    var height: CGFloat {
        switch self {
        case .zeroNewLine, .oneNewLine, .twoNewLine:
            return CGFloat(46 + self.rawValue * 22)
        case .other:
            return CGFloat(46 + 2 * 22)
        }
    }
}

final class ChatRoomViewController: UIViewController {
    
    private let viewModel = ChatRoomViewModel()
    private var input: PassthroughSubject<ChatRoomViewModel.Input, Never> = .init()
    private var messageBubbles: [MessageBubble] = []
    private var cancellables =  Set<AnyCancellable>()
    lazy private var messageTextViewHeightAnchor = messageTextView.heightAnchor.constraint(equalToConstant: 44)
    
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
        collectionView.register(OtherChatContentCollectionViewCell.self, forCellWithReuseIdentifier: OtherChatContentCollectionViewCell.className)
        collectionView.register(MyChatContentCollectionViewCell.self, forCellWithReuseIdentifier: MyChatContentCollectionViewCell.className)
        collectionView.register(MessageDateCollectionViewCell.self, forCellWithReuseIdentifier: MessageDateCollectionViewCell.className)
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
        textView.backgroundColor = .vfGray4
        textView.font = .preferredFont(forTextStyle: .callout)
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
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
    
        output.sink { [weak self] event in
            switch event {
            case .localChatDataChanged(let messageBubbles), .serverChatDataChanged(let messageBubbles):
                self?.messageBubbles = messageBubbles
                DispatchQueue.main.async {
                    self?.chatListCollectionView.reloadData()
                    let indexPath = IndexPath(item: messageBubbles.count - 1, section: 0)
                    self?.chatListCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
                }
            case .failToGetDataFromServer(let error):
                print(error.localizedDescription)
            }
        }.store(in: &cancellables)
        
        let textChangePublihser = NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification)
        textChangePublihser.sink { [weak self] _ in
            self?.messageTextViewChanged()
        }.store(in: &cancellables)
    }
    
    func configureViewModel(participatedChatRoom: ParticipatedChatRoom, user: VFUser) {
        viewModel.configure(participatedChatRoom: participatedChatRoom, user: user)
    }
}

// MARK: UI Input Event 담당 함수
extension ChatRoomViewController {
    @objc
    private func sendButtonTapped(_ sender: Any) {
        input.send(.sendButtonTapped(text: messageTextView.text))
        messageTextView.text = ""
    }
    
    private func messageTextViewChanged() {
        let textViewNewLineCount = (messageTextView.text.filter { $0 == "\n" }.count)
        if let lineCase = keyboardHeightType(rawValue: textViewNewLineCount) {
            messageTextViewHeightAnchor.constant = lineCase.height
        }
    }
}

extension ChatRoomViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageBubbles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = messageBubbles[indexPath.item]
        switch data.messageType {
        case .mine:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChatContentCollectionViewCell.className, for: indexPath) as? MyChatContentCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: data)
            return cell
            
        case .otherWithProfile, .other:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherChatContentCollectionViewCell.className, for: indexPath) as? OtherChatContentCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: data)
            return cell
            
        case .date:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageDateCollectionViewCell.className, for: indexPath) as? MessageDateCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(message: data)
            return cell
        }
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
        messageTextViewHeightAnchor.isActive = true
        let transferMessageStackViewConstraints = [
            transferMessageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transferMessageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            transferMessageStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
        ]
        
        let chatListCollectionViewConstraints = [
            chatListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatListCollectionView.bottomAnchor.constraint(equalTo: transferMessageStackView.topAnchor, constant: -20)
        ]
        
        constraintsActivate(transferMessageStackViewConstraints, chatListCollectionViewConstraints)
    }
}
