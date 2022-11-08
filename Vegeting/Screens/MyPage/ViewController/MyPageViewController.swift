//
//  MyPageViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/08.
//

import UIKit

class MyPageViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.className)
        tableView.register(MyPageProfileTableViewCell.self, forCellReuseIdentifier: MyPageProfileTableViewCell.className)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

    }

    private func setupLayout() {
        view.addSubview(tableView)
        tableView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.bottomAnchor,
                             trailing: view.trailingAnchor)
    }
}

extension MyPageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
            return 1
//        case 1: return 12
//        default: return 0
//        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageProfileTableViewCell.className, for: indexPath) as? MyPageProfileTableViewCell else { return UITableViewCell() }
            cell.configure(image: "coverImage", nickName: "내가제일잘나과", step: "플렉시테리언")
//        case 1: return 12
//        default: return 0
//        }
        return cell
    }
    
    
}

extension MyPageViewController: UITableViewDelegate {
    
}
