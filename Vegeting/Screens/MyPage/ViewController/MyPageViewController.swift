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
    
    private enum SettingElement: Int {
        case participatedClub = 1
        case termsOfUse = 3
        case privacyPolicy = 4
        case suggest = 5
        case logout = 7
        case unregister = 8
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.className)
        tableView.register(MyPageProfileTableViewCell.self, forCellReuseIdentifier: MyPageProfileTableViewCell.className)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let tableCellList: [MyPageSettingElement] = [MyPageSettingElement(text: "모임", isSmallTitle: true),
                                                         MyPageSettingElement(text: "참여한 모임", isSmallTitle: false),
                                                         MyPageSettingElement(text: "안내", isSmallTitle: true),
                                                         MyPageSettingElement(text: "이용약관", isSmallTitle: false),
                                                         MyPageSettingElement(text: "개인정보 처리방침", isSmallTitle: false),
                                                         MyPageSettingElement(text: "건의하기", isSmallTitle: false),
                                                         MyPageSettingElement(text: "계정", isSmallTitle: true),
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
    
    //MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
        Task { [weak self] in
            guard let vfUser = await FirebaseManager.shared.requestUser() else { return }
            self?.vfUser = vfUser
        }
    }

    //MARK: - func
    
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
        self.navigationItem.backButtonDisplayMode = .minimal
        self.navigationController?.navigationBar.tintColor = .black
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
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case TableSection.profile.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageProfileTableViewCell.className, for: indexPath) as? MyPageProfileTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.selectionStyle = .none
            Task {
                guard let vfUser = await FirebaseManager.shared.requestUser() else { return }
                cell.configure(imageURL: vfUser.imageURL, nickName: vfUser.userName, step: vfUser.vegetarianType)
                self.vfUser = vfUser
            }
            return cell
        case TableSection.setting.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.className, for: indexPath) as? MyPageTableViewCell else { return UITableViewCell() }
            cell.configure(with: tableCellList[indexPath.row])
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case SettingElement.participatedClub.rawValue:
            let viewController = MyClubsViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        case SettingElement.termsOfUse.rawValue:
            guard let url = URL(string: StringLiteral.termsOfUseNotionLink) else { return }
            UIApplication.shared.open(url)
        case SettingElement.privacyPolicy.rawValue:
            guard let url = URL(string: StringLiteral.privayPolicyNotionLink) else { return }
            UIApplication.shared.open(url)
        case SettingElement.suggest.rawValue:
            guard let url = URL(string: StringLiteral.suggestGoogleLink) else { return }
            UIApplication.shared.open(url)
        case SettingElement.logout.rawValue:
            makeRequestAlert(title: "로그아웃",
                             message: "정말 로그아웃 하시겠습니까?",
                             okTitle: "확인",
                             cancelTitle: "취소") { okAction in
                AuthManager.shared.requestSignOut()
            }

        case SettingElement.unregister.rawValue:
            print("unregister")
        default:
            return
        }
    }
}

extension MyPageViewController: MyPageProfileTableViewCellDelegate {
    
    func profileEditButtonTapped() {
        let viewController = MyProfileEditViewController()
        guard let vfUser = self.vfUser else { return } // return에 아직 vfuser값이 들어오지 않았을 경우 에러 처리 or 뷰 처리
        
        let profileModel = Participant(userID: vfUser.userID, name: vfUser.userName,
                                       birth: vfUser.birth,
                                       location: vfUser.location,
                                       gender: vfUser.gender,
                                       vegetarianType: vfUser.vegetarianType,
                                       introduction: vfUser.introduction,
                                       interests: vfUser.interests)
        viewController.configure(with: profileModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
