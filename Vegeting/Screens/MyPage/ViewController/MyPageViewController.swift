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
        tableView.separatorStyle = .none
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.className)
        tableView.register(MyPageProfileTableViewCell.self, forCellReuseIdentifier: MyPageProfileTableViewCell.className)
        tableView.dataSource = self
        return tableView
    }()
    
    private let tableCellList: [MyPageSettingElement] = [MyPageSettingElement(text: "모임", isSmallTitle: true),
                                                MyPageSettingElement(text: "주최한 모임", isSmallTitle: false),
                                                MyPageSettingElement(text: "설정", isSmallTitle: true),
                                                MyPageSettingElement(text: "채팅 알람", isSmallTitle: false, isSwitch: true),
                                                MyPageSettingElement(text: "차단한 사용자 관리", isSmallTitle: false),
                                                MyPageSettingElement(text: "안내", isSmallTitle: true),
                                                MyPageSettingElement(text: "공지사항", isSmallTitle: false),
                                                MyPageSettingElement(text: "고객센터", isSmallTitle: false),
                                                MyPageSettingElement(text: "게정", isSmallTitle: true),
                                                MyPageSettingElement(text: "로그아웃", isSmallTitle: false),
                                                MyPageSettingElement(text: "회원탈퇴", isSmallTitle: false)]
    
    private var vfUser: VFUser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
        setupNavigationBar()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.trailingAnchor)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "마이페이지"
    }
}

extension MyPageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return tableCellList.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageProfileTableViewCell.className, for: indexPath) as? MyPageProfileTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            Task {
                guard let vfUser = await FirebaseManager.shared.requestUser() else { return }
                cell.configure(image: "coverImage", nickName: vfUser.userName, step: "플렉시테리언")
                self.vfUser = vfUser
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.className, for: indexPath) as? MyPageTableViewCell else { return UITableViewCell() }
            
            cell.configure(with: tableCellList[indexPath.row])
            return cell
        default: return UITableViewCell()
        }
        
    }
    
    
}

extension MyPageViewController: MyPageProfileTableViewCellDelegate {
    func profileEditButtonTapped() {
        let viewController = MyProfileEditViewController()
        guard let vfUser = self.vfUser else { return } // return에 아직 vfuser값이 들어오지 않았을 경우 에러 처리 or 뷰 처리
        let modalModel = ModalModel(nickname: vfUser.userName, vegetarianStep: "플렉시테리언", ageGroup: "20대", location: "포항시 남구", gender: "여성", introduction: "사람을 좋아하고, 자연을 사랑하는 플렉시테리언입니다. 이곳에서 소중한 인연 많이 만들어갔으면 좋겠어요.")
        viewController.configure(with: modalModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}
