//
//  ReportViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/17.
//

import UIKit

extension UIViewController {
    
    struct ReportStringLiteral {
        let title: String
        let buttonTitle: String
        let alertTitle: String
        let alertMessage: String
        let headerTitle: String
        let reportElementList: [String]
    }
    
    enum ReportType {
        case report
        case block
        case unregister
        
        var stringLiteral: ReportStringLiteral {
            switch self {
                
            case .report:
                return ReportStringLiteral(title: "게시물 신고",
                                           buttonTitle: "신고합니다",
                                           alertTitle: "신고하시겠습니까?",
                                           alertMessage: "신고해주신 내용이 운영팀에 전달됩니다.",
                                           headerTitle: "신고 사유 (최대 3개 선택)",
                                           reportElementList: ["모집글 성격과 맞지 않아요.", "불쾌감을 줍니다.", "개인정보 노출 문제가 있어요", "연애/19+ 만남을 유도합니다.", "법적인 문제가 있어요", "욕설/혐오/차별적 표현이 있습니다.", "음란물입니다.", "불쾌한 표현이 있습니다.", "홍보/도배글입니다.", "기타 (직접 입력)"])
            case .block:
                return ReportStringLiteral(title: "사용자 차단",
                                           buttonTitle: "차단합니다",
                                           alertTitle: "차단하시겠습니까?",
                                           alertMessage: "차단한 사용자의 게시글이 노출되지 않습니다.",
                                           headerTitle: "‘초보채식인'\n사용자를 차단하는 이유가 무엇인가요?",
                                           reportElementList: ["불쾌감을 줍니다.", "개인정보를 유출합니다.", "욕설/혐오/차별적 표현을사용해요", "다른 목적을 가지고 접근하는 것 같아요", "불쾌한 표현을 사용해요", "홍보/도배글을 작성합니다.", "기타 (직접 입력)" ])
            case .unregister:
                return ReportStringLiteral(title: "회원 탈퇴",
                                           buttonTitle: "회원 탈퇴",
                                           alertTitle: "탈퇴하시겠습니까?",
                                           alertMessage: "더 이상 해당 계정으로 로그인할 수 없습니다.",
                                           headerTitle: "탈퇴 사유 (최대 3개 선택)",
                                           reportElementList: ["디자인이 마음에 안 들어요", "다른 더 좋은 서비스를 찾았어요.", "더 이상 채식을 하지 않아요.", "안 좋은 일을 겪었어요.", "자주 사용하지 않아요.", "원하는 모임이 없어요.", "개인정보 유출이 걱정돼요", "다른 계정이 있어요", "앱 오류가 자주 발생해요.", "기타 (직접 입력)"])
            }
        }
    }
}

final class ReportViewController: UIViewController {
    
    // MARK: - properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ReportTableViewCell.self, forCellReuseIdentifier: ReportTableViewCell.className)
        tableView.register(ReportTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: ReportTableViewHeaderView.className)
        return tableView
    }()
    
    private lazy var reportButton: BottomButton = {
        let button = BottomButton()
        button.isEnabled = false
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        button.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let reportInformationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .vfGray2
        label.text = "차단하면, 해당 사용자가 작성한 모임모집글이 보이지 않습니다.\n차단한 사용자는 마이페이지 > 차단한 사용자 관리에서 확인하고 해제할 수 있습니다. "
        label.numberOfLines = 0
        return label
    }()
    
    private var reportType: ReportType
    private var headerTitleWhenBlock: String? = nil
    private lazy var keyboardHeight: CGFloat = self.view.frame.height * 0.3
    private lazy var selectedElementList: [String] = []
    
    // MARK: - lifeCycle
    
    init(entryPoint: ReportType) {
        self.reportType = entryPoint
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardWillShow()
        setupButtonTitle()
        setupLayout()
        configureUI()
        setupNavigationBar()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    deinit {
        selectedElementList.removeAll()
    }
    
    // MARK: - func
    
    private func setupButtonTitle() {
        let buttonTitle = reportType.stringLiteral.buttonTitle
        
        reportButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = reportType.stringLiteral.title
    }
    
    private func setupLayout() {
        view.addSubviews(tableView, reportInformationLabel, reportButton)
        tableView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: reportInformationLabel.topAnchor,
                             trailing: view.trailingAnchor,
                             padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        reportInformationLabel.constraint(leading: view.leadingAnchor,
                                          bottom: reportButton.topAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: 0, left: 20, bottom: 16, right: 20))
        
        reportButton.constraint(bottom: view.keyboardLayoutGuide.topAnchor,
                                centerX: view.centerXAnchor,
                                padding: UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0))
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    @objc
    private func reportButtonTapped() {
        
        let reportTitle = reportType.stringLiteral.alertTitle
        let reportMessage = reportType.stringLiteral.alertMessage
        
        makeRequestAlert(title: reportTitle,
                         message: reportMessage,
                         okTitle: "확인",
                         cancelTitle: "취소") { _ in
            // okAction
            self.registerReport()
        }
    }
    
    private func registerReport() {
        // 기타 옵션이 체크되어 있으면 selectedElementList의 해당 내용을 작성한 내용으로 바꿔주기
        if selectedElementList.contains(StringLiteral.reportTableViewCellTextViewOtherOption) {
            let cellIndex = reportType.stringLiteral.reportElementList.count - 1
            guard let otherOptionCell = tableView.cellForRow(at: IndexPath(row: cellIndex, section: 0)) as? ReportTableViewCell else { return }
            let otherContent = otherOptionCell.readOtherContent()
            guard let contentIndex = selectedElementList.firstIndex(of: StringLiteral.reportTableViewCellTextViewOtherOption) else { return }
            selectedElementList[contentIndex] = otherContent
        }
        
        switch reportType {
        case .report:
            // TODO: 신고하기 눌렀을때
            makeAlert(title: "신고가 접수되었습니다.", message: "") { _ in
                self.navigationController?.popViewController(animated: true)
            }
            break
        case .block:
            // TODO: 차단하기 눌렀을때
            makeAlert(title: "차단되었습니다.", message: "") { _ in
                self.navigationController?.popViewController(animated: true)
            }
            break
        case .unregister:
            unregister()
        }
        
    }
    
    private func unregister() {
        FirebaseManager.shared.unregisterUser(reason: selectedElementList)
        
        let alert = UIAlertController(title: "탈퇴되었습니다.", message: "서비스를 사용하려면 다시 가입해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            NotificationCenter.default.post(name: NSNotification.Name("sceneRootViewToMainTabbar"), object: nil)
        }))
        present(alert, animated: true)
    }
    
    private func observeKeyboardWillShow() {
         NotificationCenter.default.addObserver(self,
                                                selector: #selector(calculateKeyboardHeight),
                                                name: UIResponder.keyboardWillShowNotification,
                                                object: nil)
     }

     @objc
     private func calculateKeyboardHeight(notification: NSNotification) {
         DispatchQueue.main.async { [weak self] in
             let index = (self?.reportType.stringLiteral.reportElementList.count ?? 1) - 1
             self?.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .bottom, animated: true)
         }
     }

     private func scrollVertical(to yOffset: CGFloat) {
         tableView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
     }
    
    func configureBlockUser(name: String) {
        self.headerTitleWhenBlock = "'\(name)'\n사용자를 차단하는 이유가 무엇인가요?"
    }
}

extension ReportViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportType.stringLiteral.reportElementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.className, for: indexPath) as? ReportTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.delegate = self
        
        let isOtherOption = (indexPath.row == reportType.stringLiteral.reportElementList.count - 1)
        cell.isOtherOption = isOtherOption
        cell.configure(with: reportType.stringLiteral.reportElementList[indexPath.row])
        return cell
    }
}

extension ReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReportTableViewHeaderView.className) as?  ReportTableViewHeaderView else { return UIView() }
        
        headerView.contentView.backgroundColor = .systemBackground
        switch reportType {
        case .block:
            headerView.configure(with: headerTitleWhenBlock ?? "")
        case .report, .unregister:
            headerView.configure(with: reportType.stringLiteral.headerTitle)
        }
        return headerView
    }
}

extension ReportViewController: ReportTableViewCellDelegate {
    
    func updateSelectedElement(with element: String) {
        
        let isInList = selectedElementList.contains(element)
        
        if isInList {
            guard let index = selectedElementList.firstIndex(of: element) else { return }
            selectedElementList.remove(at: index)
        } else {
            selectedElementList.append(element)
        }
        
        reportButton.isEnabled = selectedElementList.isEmpty ? false : true
        
    }
    
    func updateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
        let index = reportType.stringLiteral.reportElementList.count - 1
        tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .bottom, animated: true)
    }
    
}
