//
//  ChatRoomListViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/02.
//

import Combine
import UIKit

import FirebaseAuth

struct TempChatModel {
    let imageName: String = "coverImage"
    let title: String
    let currentNumber: Int = 5
    let latestChat: String
    var latestChatDate: Date
    let unreadChatCount: Int = 5
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
    
    var fbUser: FirebaseAuth.User?
    var user: VFUser?
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupNavigationBar()
        setupLayout()
        configureUI()
        signIn(self)
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
    
    // 추후 로그인되고 user의 정보가 AuthManager에서 저장되면 없어질 코드
    func requestUserInfo() {
        Task { [weak self] in
            user = await FirebaseManager.shared.requestUser()
            guard let user = user else { return }
            self?.user = user
            self?.bind()
        }
    }
    
    func bind() {
        guard let user = user else { return }

        FirebaseManager.shared.requestRecentChat(user: user) { result in
            switch result {
            case .success(let recentChats):
                self.chatList = recentChats.map { recentChat in
                    let title = recentChat.chatRoomName ?? ""
                    let lastestChat = recentChat.lastSentMessage ?? ""
                    let lastestChatDate = recentChat.lastSentTime ?? Date()
                    let result = TempChatModel(title: title, latestChat: lastestChat, latestChatDate: lastestChatDate)
                    return result
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
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
