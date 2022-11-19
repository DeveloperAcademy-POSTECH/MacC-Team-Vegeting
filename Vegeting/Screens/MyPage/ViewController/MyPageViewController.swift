//
//  MyPageViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/08.
//

import UIKit

class MyPageViewController: UIViewController {
    
    private enum TableSection: Int {
        case profile = 0
        case setting = 1
    }
    
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
    
    private var vfUser: VFUser? = nil {
        didSet {
            if oldValue != self.vfUser {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadSections(.init(integer: TableSection.profile.rawValue), with: .none)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { [weak self] in
            guard let vfUser = await FirebaseManager.shared.requestUser() else { return }
            self?.vfUser = vfUser
        }
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
        case TableSection.profile.rawValue:
            return 1
        case TableSection.setting.rawValue:
            return tableCellList.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case TableSection.profile.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageProfileTableViewCell.className, for: indexPath) as? MyPageProfileTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            Task {
                guard let vfUser = await FirebaseManager.shared.requestUser() else { return }
                cell.configure(image: "coverImage", nickName: vfUser.userName, step: vfUser.vegetarianType)
                self.vfUser = vfUser
            }
            return cell
        case TableSection.setting.rawValue:
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
        
        let modalModel = ModalModel(nickname: vfUser.userName, vegetarianStep: vfUser.vegetarianType, ageGroup: vfUser.birth.toAgeGroup(), location: vfUser.location, gender: vfUser.gender, introduction: "사람을 좋아하고, 자연을 사랑하는 플렉시테리언입니다. 이곳에서 소중한 인연 많이 만들어갔으면 좋겠어요.")
        
        viewController.configure(with: modalModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
