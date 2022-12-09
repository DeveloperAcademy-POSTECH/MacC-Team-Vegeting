//
//  ChatRoomListViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/02.
//

import UIKit

struct TempChatModel {
    let title: String
    let currentNumer: Int?
    let latestChat: String?
    var latestChatDate: Date
    let unreadChatCount: Int?
    let imageURL: URL?
}

class ChatRoomListViewController: UIViewController {
    
    // MARK: - properties
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: ChatRoomTableViewCell.className)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // 데이터 전달용
    private var chatList: [RecentChat] = [] 

    //  테이블 뷰  용
    private var chatListData: [TempChatModel] = [] {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        requestUserInfo()
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: selectedIndexPath, animated: true)
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
        tableView.delegate = self
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
        user = AuthManager.shared.currentUser()
        bind()
    }
    
    private func bind() {
        user = AuthManager.shared.currentUser()
        guard let user = user else { return }
        var lastReadIndexInChatRoom = calculateUnreadCountInChat(participatedChats: user.participatedChats)
        
        FirebaseManager.shared.requestRecentChat(user: user) { [weak self] result in
            switch result {
            case .success(let recentChats):
                self?.chatList = recentChats
                self?.chatListData = recentChats.map { recentChat -> TempChatModel in
                    let title = recentChat.chatRoomName ?? ""
                    let lastestChat = recentChat.lastSentMessage ?? ""
                    let lastestChatDate = recentChat.lastSentTime ?? Date()
                    let unreadMessageCount = self?.calculateUnreadMessage(messagesCount: recentChat.messagesCount,
                                                                          lastReadIndexByUser: lastReadIndexInChatRoom[recentChat.chatRoomID ?? ""])
                    let result = TempChatModel(title: title,
                                               currentNumer: recentChat.numberOfParticipants,
                                               latestChat: recentChat.lastSentMessage,
                                               latestChatDate: recentChat.lastSentTime,
                                               unreadChatCount: unreadMessageCount,
                                               imageURL: recentChat.coverImageURL)
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
            return (messagesCount - 1) - lastReadIndexByUser
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
        
        cell.configure(with: chatListData[indexPath.row])
        return cell
    }
    
}

extension ChatRoomListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ChatRoomViewController()
        let selectedChatRoom = chatList[indexPath.row]
        let participatedChatRoom = ParticipatedChatRoom(chatID: selectedChatRoom.chatRoomID,
                                                        chatName: selectedChatRoom.chatRoomName ?? "",
                                                        imageURL: selectedChatRoom.coverImageURL, lastReadIndex: nil)
        guard let user = self.user else { return }
        viewController.configureViewModel(participatedChatRoom: participatedChatRoom, user: user)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
