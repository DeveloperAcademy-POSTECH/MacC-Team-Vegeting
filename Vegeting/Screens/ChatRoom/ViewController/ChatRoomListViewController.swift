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
    
    private var chatList: [RecentChat] = [] {
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
        Task { [weak self] in
            self?.user = await FirebaseManager.shared.requestUser()
            guard let user = user else { return }
            self?.user = user
            self?.bind()
        }
    }
    
    private func bind() {
        guard let user = user else { return }
        
        FirebaseManager.shared.requestRecentChat(user: user) { result in
            switch result {
            case .success(let recentChats):
                self.chatList = recentChats
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

extension ChatRoomListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ChatRoomViewController()
        let selectedChatRoom = chatList[indexPath.row]
        let participatedChatRoom = ParticipatedChatRoom(chatID: selectedChatRoom.chatRoomID,
                                                        chatName: selectedChatRoom.chatRoomName ?? "",
                                                        imageURL: selectedChatRoom.coverImageURL)
        guard let user = self.user else { return }
        viewController.configureViewModel(participatedChatRoom: participatedChatRoom, user: user)
        navigationController?.pushViewController(viewController, animated: true)
        
    }
}
