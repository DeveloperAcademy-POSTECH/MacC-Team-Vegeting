//
//  ChatRoomListViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/02.
//

import UIKit

struct TempChatModel {
    let imageName: String = "coverImage"
    let title: String
    let currentNumer: Int = 5
    let latestChat: String
    var latestChatDate: Date
    let unreadChatCount: Int?
}

class ChatRoomListViewController: UIViewController {
    
    // MARK: - properties
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: ChatRoomTableViewCell.className)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var chatList: [TempChatModel] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private var user: VFUser? = nil
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupNavigationBar()
        setupLayout()
        configureUI()
        requestUserInfo()
    }
    
    // MARK: - func
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.bottomAnchor,
                             trailing: view.trailingAnchor)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        let navigationTitleLabel = UILabel()
        navigationTitleLabel.text = "내가 참여한 모임"
        navigationTitleLabel.font = .preferredFont(forTextStyle: .title2,
                                                   compatibleWith: .init(legibilityWeight: .bold))
        let leftBarButtonItem = UIBarButtonItem(customView: navigationTitleLabel)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    func requestUserInfo() {
        Task { [weak self] in
            self?.user = await FirebaseManager.shared.requestUser()
            guard let user = user else { return }
            self?.user = user
            self?.bind()
        }
    }
    
    private func bind() {
        guard let user = user else { return }
        
        var lastReadIndexInChatRoom = calculateUnreadCountInChat(participatedChats: user.participatedChats)
        
        FirebaseManager.shared.requestRecentChat(user: user) { [weak self] result in
            switch result {
            case .success(let recentChats):
                self?.chatList = recentChats.map { recentChat in
                    let title = recentChat.chatRoomName ?? ""
                    let lastestChat = recentChat.lastSentMessage ?? ""
                    let lastestChatDate = recentChat.lastSentTime ?? Date()
                    let unreadMessageCount = self?.calculateUnreadMessage(messagesCount: recentChat.messagesCount,
                                                                          lastReadIndexByUser: lastReadIndexInChatRoom[recentChat.chatRoomID ?? ""])
                    let result = TempChatModel(title: title, latestChat: lastestChat, latestChatDate: lastestChatDate,  unreadChatCount: unreadMessageCount)
                    return result
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// 참여한 채팅방에 마지막으로 읽은 Index를 알려주는 Dictionary
    private func calculateUnreadCountInChat(participatedChats: [ParticipatedChatRoom]?) -> [String: Int] {
        var result = [String: Int]()
        guard let participatedChats = participatedChats else { return result }
        participatedChats.forEach {
            if let chatID = $0.chatID, let lastReadIndex = $0.lastReadIndex {
                result.updateValue(lastReadIndex, forKey: chatID)
            }
        }
        return result
    }
    
    ///  안읽은 메세지 수 계산(채팅방 메시지 - 해당 유저가 마지막으로 읽은 index)
    private func calculateUnreadMessage(messagesCount: Int?, lastReadIndexByUser: Int?) -> Int {
        if let messagesCount = messagesCount, let lastReadIndexByUser = lastReadIndexByUser {
            return messagesCount - lastReadIndexByUser
        } else {
            return 0
        }
    }
}

extension ChatRoomListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewCell.className) as? ChatRoomTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: chatList[indexPath.row])
        return cell
    }
    
}
