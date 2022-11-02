//
//  ChatRoomListViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/02.
//

import UIKit

struct TempChatModel {
    let imageName: String = "coverImage"
    let title: String = "안녕안녕돼지가든입니다."
    let currentNumer: Int = 5
    let latestChat: String = "이거이거 우리 워케이션 갈까요 말까요?"
    let latestChatDate: Date = Date()
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
    
    private let chatList: [TempChatModel] = [TempChatModel(), TempChatModel(), TempChatModel(), TempChatModel()]

    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupLayout()
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
